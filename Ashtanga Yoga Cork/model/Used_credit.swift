//
//  Used_credit.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class Used_credit: ObservableObject {
    @Published var txn_id: String = ""
    @Published var purchase_date: String = ""
    @Published var expiry_date: String = ""
    @Published var class_type_restriction: String = ""
    @Published var num_tokens: String = ""
    
    init(id: String, pd: String, ed: String, ctr: String, nt: String){
        self.txn_id = id
        self.purchase_date = pd
        self.expiry_date = ed
        self.class_type_restriction = ctr
        self.num_tokens = nt
    }
}

class Used_credits: ObservableObject {
    @Published var used_credits: [Used_credit] = [Used_credit]()
}
