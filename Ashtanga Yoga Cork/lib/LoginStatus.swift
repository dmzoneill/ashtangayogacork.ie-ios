//
//  LoginStatus.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 03/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

struct LoginStatus {
    let action: String
    let result: Bool
    let error: String
    
    init(a: String, r: Bool, e: String) {
        action = a
        result = r
        error = e
    }
}
