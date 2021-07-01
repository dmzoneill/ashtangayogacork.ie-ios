//
//  DateRule.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 24/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct DateRule: View {
    let text: String
    var body: some View {
        HStack {
            Text(self.text)
                .font(Common.Ufont16Bold)
                .foregroundColor(Color.init(hex: 0x000000))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
        }
        .background(Color.init(hex: 0x999999))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    init(_ str: String) {
        self.text = str
    }
}
