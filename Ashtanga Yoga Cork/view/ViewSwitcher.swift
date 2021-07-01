//
//  ViewSwitcher.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 26/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

class RootView: ObservableObject {
    @Published var rootView: Int = 0
}

struct ViewSwitcher: View, Observer {
    @ObservedObject public var rootView = RootView()
    @ObservedObject var apierrorobj: ApiError = ApiError("","")
    
    private var loginView: LoginView = LoginView()
    private var mainView: MainView = MainView()
    private var aycNavigation: AycNavigtion = AycNavigtion()
    private var purchaseView: PurchaseView = PurchaseView()
    private var bugReporterView: BugReporterView = BugReporterView()
    private var receiptView: ReceiptView = ReceiptView()
    private var voucherView: VoucherView = VoucherView()
    private var settingsView: SettingsView = SettingsView()
    private var socialLoginView: SocialLoginView = SocialLoginView()
    
    var body: some View {
        ZStack {
            Group {
                if self.rootView.rootView == 1 {
                    self.loginView
                }
                else if self.rootView.rootView == 2 {
                    self.aycNavigation
                }
                else if self.rootView.rootView == 3 {
                    self.purchaseView
                }
                else if self.rootView.rootView == 4 {
                    self.bugReporterView
                }
                else if self.rootView.rootView == 5 {
                    self.receiptView
                }
                else if self.rootView.rootView == 6 {
                    self.voucherView
                }
                else if self.rootView.rootView == 7 {
                    self.settingsView
                }
                else if self.rootView.rootView == 8 {
                    self.socialLoginView
                }
                else {
                    self.mainView
                }
            }
            if self.rootView.rootView != 4 {
                BugButton()
            }
        }.alert(isPresented: $apierrorobj.shown) {
            Alert(title: Text(self.apierrorobj.title),
                  message: Text(self.apierrorobj.description),
                  dismissButton: .default(Text("Okay")) {self.apierrorobj.shown = false})
        }
    }
    
    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        if error.title != "" {
            print("Displaying error: " + error.title + ": " + error.description)
            self.apierrorobj.title = error.title
            self.apierrorobj.description = error.description
            self.apierrorobj.shown = true
        }
    }
    
    init() {
        let sm = ScraperManager.getInstance()
        sm.attach(obj: self)
        sm.attach(obj: self.aycNavigation)
        sm.attach(obj: self.loginView)
        sm.attach(obj: self.bugReporterView)
        sm.attach(obj: self.purchaseView)
        sm.attach(obj: self.receiptView)
        sm.attach(obj: self.voucherView)
        sm.attach(obj: self.socialLoginView)
    }
}
