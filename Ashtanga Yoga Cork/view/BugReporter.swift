//
//  BugReporter.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 27/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct BugReporterView: View, Observer {
    @State private var title: String = ""
    @State private var description: String = AYCDevice.getDescription()
    @State private var showingAlert = false
    
    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            BackButton(UpdateSource.bug)
            SectionHeader("Bug report")
            .padding(EdgeInsets(top: 10,
                                leading: 5,
                                bottom: 0,
                                trailing: 5))
            Text("We're sorry you had a problem with the app.  Thanks for taking the time to provide feedback.")
                .font(Common.Ufont14)
                .lineLimit(nil)
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 0, trailing: 5))
            GaneshSpacer()
            Text("Title")
            .font(Common.Ufont16Bold)
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
            TextField("A short description", text: $title)
                .font(Common.Ufont14)
                .multilineTextAlignment(.center)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 45, alignment: .center)
                .border(Color(hex: 0x7e8993), width: 2)
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            Text("Description")
            .font(Common.Ufont16Bold)
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            ScrollableTextView(text: $description)
                .padding(8.0)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .border(Color(hex: 0x7e8993), width: 2)
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            Button(action: {
                self.showingAlert = true
                ScraperManager.getInstance().create_issue(title: self.title, description: self.description, user: ScraperManager.get_profile().wp_user.display_name)
            }) {
                Text("Submit Bug").font(Common.Ufont14Bold)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Bug Sumitted"),
                          message: Text("Thank you for contributing"),
                          dismissButton: Alert.Button.default(Text("Okay"), action:
                            {
                                ScraperManager.getInstance().notify(source: UpdateSource.bug, requestview: RequestedView.goback, loginstate: ScraperManager.login_status!, payload: Payload( ""), error: ApiError("",""))
                            }
                        )
                    )
                }
                .buttonStyle(ImageButton())
                .frame(width: 100, height: 40, alignment: .center)
                .foregroundColor(Color.white)
                .background(Color.red)
                .border(Color.black, width: 2)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 15, trailing: 5))
        }
        .padding(10)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }

    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
    }
}
