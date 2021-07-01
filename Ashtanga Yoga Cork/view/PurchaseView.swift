//
//  WebView.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 25/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit
import UIKit
import Combine

class WebViewModel: ObservableObject {
    @Published public var didFinishLoading: Bool = false
    @Published public var paypalid: String = ""
    @Published public var transactionSuccess: Bool = false
}

struct PurchaseView: View, Observer {
    @ObservedObject var model: WebViewModel = BuyView.viewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {}) {Text("")}
                .alert(isPresented: $model.transactionSuccess) {
                    Alert(title: Text("Transaction " + (BuyView.viewModel.transactionSuccess ? "success" : "failed") ),
                      message: Text((BuyView.viewModel.transactionSuccess ? "Thank you for your purchase" : "Unfortunately the transaction failed to be added to your account.  Please contact us with your paypal transaction number if in doubt")),
                      dismissButton: Alert.Button.default(Text("Okay"), action:
                        {
                            ScraperManager.getInstance().fetch_all()
                            ScraperManager.getInstance().notify(source: UpdateSource.purchase,
                                                                requestview: RequestedView.navprofile,
                                                                loginstate: ScraperManager.login_status!,
                                                                payload: Payload(""),
                                                                error: ApiError("",""))
                        }
                    ))
                }
                .frame(width:0, height:0)
            BackButton(UpdateSource.purchase, true)
            BuyView()
        }
    }
    
    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        if(source == UpdateSource.purchase && requestview == RequestedView.purchase) {
            model.transactionSuccess = model.transactionSuccess
        }
    }
}

struct BuyView: UIViewRepresentable {
    @ObservedObject public static var viewModel: WebViewModel = WebViewModel()

    let webView = WKWebView()

    func makeUIView(context: UIViewRepresentableContext<BuyView>) -> WKWebView {
        self.webView.navigationDelegate = context.coordinator
                
        for cookie_obj in ScraperManager.get_cookies_array() {
            let cookie = HTTPCookie(properties: [
                .domain: "ashtangayoga.ie",
                .path: "/",
                .name: cookie_obj.key,
                .value: cookie_obj.value,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31556926)
            ])!
            self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        var urlRequest = URLRequest(url: URL(string: "https://www.paypal.com/cgi-bin/webscr")!)
        urlRequest.httpShouldHandleCookies = true
        
        if BuyView.viewModel.paypalid.count > 0 {
            urlRequest.httpMethod = "POST"
            let params = "cmd=_s-xclick&hosted_button_id=" + BuyView.viewModel.paypalid + "&submit.x=83&submit.y=7";
            urlRequest.httpBody = params.data(using: .utf8)
        }
        
        self.webView.load(urlRequest)
        return self.webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<BuyView>) {
        return
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel = BuyView.viewModel

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView: navigation finished")
            self.viewModel.didFinishLoading = true
            webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (value: Any!, error: Error!) -> Void in
                if error != nil {
                    return
                }

                let result = value as? String ?? ""
                print(webView.url?.host! ?? "")
                
                if (webView.url?.host?.contains("ashtangayoga"))! {
                    if result.contains("Sorry to see you cancelled your transaction, maybe next time") ||
                        result.contains("There was an error with your transaction") {
                        print("Transaction failed")
                        
                        self.viewModel.transactionSuccess = false
                    } else if result.contains("Thank you for completing your transaction") {
                        print("Transaction success")
                        self.viewModel.transactionSuccess = true
                    }
                    ScraperManager.getInstance().notify(source: .purchase, requestview: .purchase, loginstate: ScraperManager.login_status!, payload: Payload(""), error: ApiError("",""))
                    print(result)
                }
            })
        }
    }

    func makeCoordinator() -> BuyView.Coordinator {
        Coordinator()
    }
}
