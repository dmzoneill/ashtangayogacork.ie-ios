//
//  GradientBackgroundStyle.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 24/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: 100)
            .cornerRadius(29)
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            .background(Color.init(hex: 0xDDDDDD))
            .border(Color.init(hex: 0xCCCCCC), width: 1)
            .scaleEffect(configuration.isPressed ? 0.6 : 1.0)
            .shadow(radius: 5)
    }
}
