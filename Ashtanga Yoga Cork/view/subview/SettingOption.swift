//
//  SettingOption.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 03/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SettingOption<Content: View>: View {
    let disabled: Bool
    let option: String
    let description: String
    let content: () -> Content
    
    var body: some View {
        HStack {
            VStack {
                Text(self.option)
                        .font(Common.Ufont16Bold)
                        .foregroundColor(self.disabled ? Color.gray : Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minWidth: 240, maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 5,
                                            leading: 10,
                                            bottom: 5,
                                            trailing: 5))
                Text(self.description)
                        .font(Common.Ufont14)
                        .foregroundColor(self.disabled ? Color.gray : Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0,
                                            leading: 10,
                                            bottom: 10,
                                            trailing: 5))
                        .frame(minWidth: 220, maxWidth: .infinity, alignment: .leading)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            self.content()
                    .padding(EdgeInsets(top: 10,
                                        leading: 5,
                                        bottom: 10,
                                        trailing: 5))
                    .frame(minWidth: 0, maxWidth: 80, alignment: .leading)
        }.frame(minWidth: 0, maxWidth: .infinity)
    }
    
    init(_ disabled: Bool,
         _ option: String,
         _ description: String = "",
         @ViewBuilder content: @escaping () -> Content) {
        self.disabled = disabled
        self.option = option
        self.description = description
        self.content = content
    }
}
