//
//  PaypalButton.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 24/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct PayPalButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.6 : 1.0)
            .frame(width: 80)
            .padding(5)
    }
}
