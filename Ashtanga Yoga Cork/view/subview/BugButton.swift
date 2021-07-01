//
//  BugButton.swift
//  Ashtanga Yoga Cork
//
//  Created by daoneill on 19/06/2021.
//

import Foundation
import SwiftUI

struct BugButton: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Button(action: {
                    ScraperManager.getInstance().notify(source: UpdateSource.login, requestview: RequestedView.bug, loginstate: ScraperManager.login_status!, payload: Payload(""), error: ApiError("",""))
                }, label: {
                    Text("!")
                        .font(Common.UfontBoldML)
                    .frame(width: 36, height: 30)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 3)
                })
                .buttonStyle(ImageButton())
                .background(RoundedCorners(color: .red, tl: 30, tr: 30, bl: 30, br: 0))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 70, trailing: 0))
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            }
        }
    }
}

