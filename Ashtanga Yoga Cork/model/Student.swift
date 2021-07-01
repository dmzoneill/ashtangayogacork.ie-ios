//
//  Student.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class Student : ObservableObject {
    @Published var id: String = ""
    @Published var wp_uid: String = ""
    @Published var level: String = ""
    @Published var phone: String = ""
    @Published var email_alerts: Bool = false
    @Published var sms_alerts: Bool = false
    @Published var last_online: String = ""
    @Published var last_online_ios: String = ""
    @Published var last_online_android: String = ""
    @Published var deletion_date: String = ""
}
