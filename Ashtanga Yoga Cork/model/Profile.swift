//
//  Profile.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class Profile : ObservableObject {
    @Published var wp_user: WP_user
    @Published var student: Student
    @Published var credits: Credits
    
    init(w: WP_user, s: Student, c: Credits){
        self.wp_user = w;
        self.student = s;
        self.credits = c;
    }
}
