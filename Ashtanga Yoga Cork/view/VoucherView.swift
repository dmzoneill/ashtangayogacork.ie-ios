//
//  VoucherView.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 01/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct VoucherView: View, Observer {
    @ObservedObject var voucherImg = VoucherImage()

    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            BackButton(UpdateSource.bug)
            VStack (alignment: .center) {
                Spacer()
                AsyncImage(
                    url: URL(string: self.voucherImg.url)!
                    ,
                    placeholder: Image("login_logo")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 0,  maxHeight: .infinity, alignment: .center)
                        .padding(.bottom, 10.0)
                ).aspectRatio(contentMode: .fit)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
    }
    
    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        if source == UpdateSource.scraper && requestview == RequestedView.voucher {
            let pl = payload.payload as? DownloadTaskComplete ?? nil
            if pl != nil {
                var voucher_url = pl!.voucherUrl!
                voucher_url = voucher_url.trimmingCharacters(in: .whitespacesAndNewlines) + "&r=t"
                print("Voucher url here: " + voucher_url)
                self.voucherImg.url = voucher_url
            }
        }
    }
}
