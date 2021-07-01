//
//  AycNavigation.swift
//  Ashtanga Yoga Cork
//
//  Created by Dave on 06/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AycNavigtion: View, Observer {
    @State var selection = 2
    
    var body: some View {
        TabView(selection:$selection) {
            ScrollView(.vertical) {
                TabPrices().background(Image("background").resizable(resizingMode: .tile))
            }.tabItem {
                Image(systemName: "eurosign.circle.fill")
                Text("Prices")
            }.tag(1)
            
            ScrollView(.vertical) {
                TabProfile().background(Image("background").resizable(resizingMode: .tile))
            }.tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }.tag(2)
            
            ScrollView(.vertical) {
                TabClasses().background(Image("background").resizable(resizingMode: .tile))
            }.tabItem {
                Image(systemName: "calendar.circle.fill")
                Text("Classes")
            }.tag(3)
        }.padding(.all, 10.0)
    }
    
    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
    }
}

struct AycNavigtion_Previews: PreviewProvider {
    static var previews: some View {
        AycNavigtion()
    }
}
