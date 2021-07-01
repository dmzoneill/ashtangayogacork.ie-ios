//
//  WP_user.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class WP_user : ObservableObject {
    @Published var ID: String = ""
    @Published var user_login: String = ""
    @Published var user_pass: String = ""
    @Published var user_nicename: String = ""
    @Published var user_email: String = ""
    @Published var user_url: String = ""
    @Published var user_registered: String = ""
    @Published var user_activation_key: String = ""
    @Published var user_status: String = ""
    @Published var display_name: String = ""
    @Published var user_avatar_url: String = "https://ashtangayoga.ie/wp-content/uploads/2020/02/cropped-ayc-logo.png"
}
