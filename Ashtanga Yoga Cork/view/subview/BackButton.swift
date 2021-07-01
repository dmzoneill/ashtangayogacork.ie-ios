//
//  BackButton.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 29/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI


struct BackButton: View {
    let source: UpdateSource
    let refresh: Bool
    
    var body: some View {
        HStack {
            Button(action:{
                withAnimation {
                    if self.refresh {
                        ScraperManager.getInstance().fetch_all()
                    }
                    ScraperManager.getInstance().notify(source: self.source,
                                                        requestview: RequestedView.goback,
                                                        loginstate: ScraperManager.login_status!,
                                                        payload: Payload( ""),
                                                        error: ApiError("",""))
                }
            }) {
                Text("< Back").font(Common.Ufont16Bold)
            }
            .buttonStyle(ImageButton())
            .frame(width: 60, height: 24)
            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 0))
            Image("sticker_ganesh")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 90))
        }//.border(Color.red)
    }
    init(_ source: UpdateSource, _ refresh: Bool = false) {
        self.source = source
        self.refresh = refresh
    }
}
