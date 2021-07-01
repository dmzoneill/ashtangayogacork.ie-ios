//
//  Price.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class Price: ObservableObject {
    @Published var id: String = ""
    @Published var enabled: String = ""
    @Published var monthly: String = ""
    @Published var user_level: String = ""
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var paypal_button_id: String = ""
    @Published var paypal_button_code: String = ""
    @Published var start_date: String = ""
    @Published var end_date: String = ""
    @Published var start_time: String = ""
    @Published var end_time: String = ""
    @Published var credits: String = ""
    @Published var credit_expiry: String = ""
    @Published var purchase_count: String = ""
    @Published var registered_after: String = ""
    @Published var class_type_restriction: String = ""
    
    init(id: String, en: String, mth: String, ul: String, nm: String, p: String, pbi: String, pbc: String, sd: String,
         ed: String, st: String, et: String, c: String, ce: String, pc: String, ra: String, ctr: String){
        self.id = id
        self.enabled = en
        self.monthly = mth
        self.user_level = ul
        self.name = nm
        self.price = p
        self.paypal_button_id = pbi
        self.paypal_button_code = pbc
        self.start_date = sd
        self.end_date = ed
        self.start_time = st
        self.end_date = et
        self.credits = c
        self.credit_expiry = ce
        self.purchase_count = pc
        self.registered_after = ra
        self.class_type_restriction = ctr
    }
}

class Prices: ObservableObject {
    @Published var standard_prices: [Price] = [Price]()
    @Published var special_prices: [Price] = [Price]()
    @Published var monthlies_prices: [Price] = [Price]()
}
