//
//  Transaction.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class Transaction: ObservableObject {
    @Published var id: String = ""
    @Published var pname: String = ""
    @Published var purchase_date: String = ""
    @Published var purchase_amount: String = ""
    @Published var class_type: String = ""
    @Published var rname: String = ""
    @Published var payer_email: String = ""
    @Published var txn_id: String = ""
    @Published var first_name: String = ""
    @Published var last_name: String = ""
    @Published var used_tokens: String = ""
    
    init(id: String, pn: String, pd: String, pa: String, ct: String, rn: String, pe: String, tx: String, fn: String, ln: String, ut: String){
        self.id = id
        self.pname = pn
        self.purchase_date = pd
        self.purchase_amount = pa
        self.class_type = ct
        self.rname = rn
        self.payer_email = pe
        self.txn_id = tx
        self.first_name = fn
        self.last_name = ln
        self.used_tokens = ut
    }
}

class Transactions: ObservableObject {
    @Published var transactions: [Transaction] = [Transaction]()
}
