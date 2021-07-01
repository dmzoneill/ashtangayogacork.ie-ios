//
//  SettingsView.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 03/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    let smsalerts = Binding<Bool> (
        get: { ScraperManager.get_profile().student.sms_alerts  },
        set: { newValue in
            ScraperManager.get_profile().student.sms_alerts = newValue
            ScraperManager.getInstance().save_settings()
        }
    )
    let emailalerts = Binding<Bool> (
        get: { ScraperManager.get_profile().student.email_alerts  },
        set: { newValue in
            ScraperManager.get_profile().student.email_alerts = newValue
            ScraperManager.getInstance().save_settings()
        }
    )
    @State private var showingupdate: Bool = false
    @ObservedObject private var student: Student = ScraperManager.get_profile().student
    
    var body: some View {
        VStack {
            BackButton(UpdateSource.settings)
            VStack(alignment: .leading, spacing: 20) {
                Text("Profile")
                    .font(Common.Ufont14Bold)
                    .foregroundColor(Color.red)
                SettingOption(true, "Profile", "Set your profile image on gravatar.com") {
                    Spacer()
                }
                SettingOption(false, "Phone number", "Used only for late cancellations") {
                    Button(action: {
                        self.showingupdate = true
                    }){
                        Text("Update")
                    }
                }
                Divider()
                Text("Notifications")
                    .font(Common.Ufont14Bold)
                    .foregroundColor(Color.red)
                SettingOption(false, "Email", "Enable or disable email notifications") {
                    Toggle(isOn: self.emailalerts){
                        Text("").frame(width:0, height: 0)
                        
                    }.toggleStyle(DefaultToggleStyle())
                        .padding(.all, 0)
                }
                SettingOption(false, "SMS", "Enable or disable sms notifications") {
                    Toggle(isOn: self.smsalerts){
                        Text("")
                        .frame(width:0, height: 0)
                        
                    }.toggleStyle(DefaultToggleStyle())
                        .padding(.all, 0)
                }
                Divider()
                Spacer().alert(isPresented: self.$showingupdate,
                       TextAlert(title: "Updating phone number",
                                 placeholder: self.student.phone,
                                 cvalue: self.student.phone,
                                 accept: "Update",
                                 action: {
                                    if $0 != nil {
                                        let code = $0
                                        if code!.count > 4 {
                                            print("Phone number: " + code!)
                                            self.student.phone = code!
                                            ScraperManager.getInstance().save_settings()
                                            return
                                        }
                                    }
                                    else {
                                        print("Cancelled")
                                    }
                                 }
                    )
                )
            }
            .padding(.all, 10.0)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        .background(Image("background")
        .resizable(resizingMode: .tile))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(hex: 0xFFFFFF))
    }
}
