//
//  SocialLogin.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 10/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit
import UIKit
import Combine

class SocialWebViewModel: ObservableObject {
    @Published public var didFinishLoading: Bool = false
    @Published public var facebook: Bool = true
}

struct SocialLoginView: View, Observer {
    @ObservedObject var model: SocialWebViewModel = SLView.viewModel
    
    var body: some View {
        VStack(spacing: 0) {
            BackButton(UpdateSource.social, false)
            SLView()
        }
    }
    
    func update(source: UpdateSource,
                requestview: RequestedView,
                loginstate: LoginStatus,
                payload: Payload,
                error: ApiError) {
    }
}

struct SLView: UIViewRepresentable {
    @ObservedObject public static var viewModel: SocialWebViewModel = SocialWebViewModel()

    let webView = WKWebView()

    func makeUIView(context: UIViewRepresentableContext<SLView>) -> WKWebView {
        self.webView.navigationDelegate = context.coordinator
        
        var urlRequest: URLRequest;
                
        if SLView.viewModel.facebook {
            urlRequest = URLRequest(url: URL(string: "https://ashtangayoga.ie/wp-login.php?loginSocial=facebook&redirect=https%3A%2F%2Fashtangayoga.ie%2F")!)
        } else {
            urlRequest = URLRequest(url: URL(string: "https://ashtangayoga.ie/wp-login.php?loginSocial=google&redirect=https%3A%2F%2Fashtangayoga.ie%2F")!)
        }
        urlRequest.httpShouldHandleCookies = true
        
        self.webView.customUserAgent = "Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36"
        self.webView.load(urlRequest)
        return self.webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<SLView>) {
        return
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: SocialWebViewModel = SLView.viewModel

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView: navigation finished")
            self.viewModel.didFinishLoading = true
            webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (value: Any!, error: Error!) -> Void in
                if error != nil {
                    return
                }

                print(webView.url?.host! ?? "")
                
                if((webView.url?.host!.contains("ashtangayoga.ie"))! && webView.url?.path.contains("wp-login.php") == false) {
                    
                    webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                        for cookie in cookies {
                            ScraperManager.getInstance().add_social_cookies(cookie: cookie)
                        }
                        ScraperManager.getInstance().notify(
                        source: UpdateSource.social,
                        requestview: RequestedView.login,
                        loginstate: ScraperManager.login_status!,
                        payload: Payload(""),
                        error: ApiError("", ""))
                    }
                }
            })
        }
    }

    func makeCoordinator() -> SLView.Coordinator {
        Coordinator()
    }
}
