//
//  ContentView.swift
//  Ashtanga Yoga Cork
//
//  Created by daoneill on 18/06/2021.
//

import SwiftUI

struct ContentView: View, Observer {
    static var viewSwticher: ViewSwitcher = ViewSwitcher()
    static var previousView: Int = 1
    
    var body: some View {
        ContentView.viewSwticher
    }
    
    init() {
        let sm = ScraperManager.getInstance()
        sm.attach(obj: self)
        sm.fetch_async(action: "check_logged_in",postfields: "")
    }
    
    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        ContentView.update(source: source, requestview: requestview, loginstate: loginstate, payload: payload, error: error)
    }
    
    static func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        if previousView == 2 || previousView == 3 {
            if ScraperManager.login_status?.result == false {
                previousView = 1
            }
        }
        
        switch requestview {
            case RequestedView.main:
                previousView = 0
                viewSwticher.rootView.rootView = 0
            case RequestedView.login:
                previousView = 1
                viewSwticher.rootView.rootView = 1
            case RequestedView.navprofile, RequestedView.navclasses, RequestedView.navprices:
                if ScraperManager.login_status != nil {
                    if ScraperManager.login_status!.result {
                        previousView = 2
                        viewSwticher.rootView.rootView = 2
                    } else {
                        previousView = 1
                        viewSwticher.rootView.rootView = 1
                    }
                } else {
                    viewSwticher.rootView.rootView = 2
                }
            case RequestedView.purchase:
                if ScraperManager.login_status != nil {
                    if ScraperManager.login_status!.result {
                        previousView = 3
                        viewSwticher.rootView.rootView = 3
                    } else {
                        previousView = 1
                        viewSwticher.rootView.rootView = 1
                    }
                } else {
                    viewSwticher.rootView.rootView = 2
                }
            case RequestedView.bug:
                viewSwticher.rootView.rootView = 4
            case RequestedView.receipt:
                viewSwticher.rootView.rootView = 5
            case RequestedView.voucher:
                viewSwticher.rootView.rootView = 6
            case RequestedView.settings:
                viewSwticher.rootView.rootView = 7
            case RequestedView.social:
                viewSwticher.rootView.rootView = 8
            case RequestedView.goback:
                viewSwticher.rootView.rootView = previousView
            case RequestedView.nochange:
                viewSwticher.rootView.rootView = viewSwticher.rootView.rootView
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
