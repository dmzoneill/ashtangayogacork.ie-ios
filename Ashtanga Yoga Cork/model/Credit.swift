//
//  Credit.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class Credit : ObservableObject {
    @Published var credits_available: String = ""
    @Published var available_monthlys: Int = 0
    @Published var credit_types: [[String]] = [[String]]()
}

class Credits: ObservableObject {
    @Published var credits: Credit = Credit()
}
