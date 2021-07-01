//
//  section.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//
import Foundation
import SwiftUI
import Combine

struct Section<Content: View>: View {
    let headerText: String
    let content: () -> Content
    var width: CGFloat = 0
    var height: CGFloat = 0
    var maxWidth: CGFloat = .infinity
    var maxHeight: CGFloat = .infinity
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeader(self.headerText)
                .padding(EdgeInsets(top: 0,
                                    leading: 10,
                                    bottom: 0,
                                    trailing: 6))
            self.content()
                .padding(EdgeInsets(top: 15,
                                    leading: 6,
                                    bottom: 0,
                                    trailing: 6))
                .frame(maxWidth: .infinity)
            GaneshSpacer()
        }.frame(maxWidth: .infinity)
    }
    
    init(_ headerText: String,
         _ minw: CGFloat = 0,
         _ minh: CGFloat = 0,
         _ maxw: CGFloat = .infinity,
         _ maxh: CGFloat = .infinity,
         @ViewBuilder content: @escaping () -> Content) {
        self.headerText = headerText
        self.content = content
        self.width = minw
        self.height = minh
        self.maxWidth = maxw
        self.maxHeight = maxh
    }
}
