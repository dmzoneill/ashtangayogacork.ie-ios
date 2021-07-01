//
//  GaneshSpacer.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct GaneshSpacer: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("sticker_ganesh")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
            Spacer().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 0)
        }//.border(Color.black)
    }
}
