//
//  DownloadTaskComplete.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 02/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

struct DownloadTaskComplete {
    var pdfurl: URL?
    var voucherUrl : String?
    var data: Data?
    
    init(_ pdfurl: URL? = nil, _ data: Data? = nil, _ voucher: String? = nil){
        self.pdfurl = pdfurl
        self.data = data
        self.voucherUrl = voucher
    }
}
