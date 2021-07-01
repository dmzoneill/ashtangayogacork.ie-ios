//
//  RowStack.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct RowStack<Content: View>: View {
    let rows: Int
    let empty: String
    let content: (Int) -> Content
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    self.content(row)
                }
                //.background(row % 2 > 0 ? Color(hex: 0xEEEEEE) : Color(hex: 0xFFFFFF, alpha: 0.0))
                .frame(maxWidth: .infinity)
            }
            if self.rows == 0 {
                HStack {
                    Text(self.empty).font(Common.Ufont14).fixedSize(horizontal: false, vertical: true)
                }.padding(10)
            }
        }
    }
    
    init(rows: Int, empty: String, @ViewBuilder content: @escaping (Int) -> Content) {
        self.rows = rows
        self.empty = empty
        self.content = content
    }
}
