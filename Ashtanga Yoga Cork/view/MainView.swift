//
//  Main.swift
//  Ashtanga Yoga Cork
//
//  Created by Dave on 11/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var shouldAnimate = true
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 20){
                Image("login_logo").resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200.0, height: 200.0, alignment: .center)
                    .padding(.bottom, 30.0)
                ActivityIndicator(shouldAnimate: self.$shouldAnimate)
            }
            .padding(.all, 60.0)
            .frame(width: 250.0, height: 600.0)
        }
        .background(Image("background").resizable(resizingMode: .tile))
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(hex: 0xFFFFFF))
    }
}
