//
//  HorizontalRule.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 24/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct HorizontalRule: View {
    let color: Color = Color.init(hex: 0xFF0000)
    let width: CGFloat = 2
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
            .padding(0)
    }
}
