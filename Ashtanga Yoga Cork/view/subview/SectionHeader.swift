//
//  SectionHeader.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SectionHeader: View {
    var title: String
    var letter: String = ""
    var remainder: String = ""
    
    var body: some View {
        HStack(spacing: 0){
            Text(self.letter).font(Common.headerLetterFont).foregroundColor(Color.red).padding(.all, 0)
            Text(self.remainder).fontWeight(Font.Weight.heavy).font(Common.headerRemainderFont).padding(.top, 2)
        }//.border(Color.black)
    }
    init(_ title: String) {
        self.title = title
        self.letter = String(self.title.prefix(1))
        self.remainder = String(self.title.suffix(self.title.count - 1))
    }
}
