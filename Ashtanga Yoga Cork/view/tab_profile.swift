//
//  tab_profile.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct TabProfile: View {
    @State private var username = ""
    @ObservedObject var wp_user = ScraperManager.get_profile().wp_user
    @ObservedObject var transactions = ScraperManager.get_transactions()
    @ObservedObject var expiring_credits = ScraperManager.get_expiring_credits()
    @ObservedObject var used_credits = ScraperManager.get_used_credits()
    @ObservedObject var bookings = ScraperManager.get_bookings()
    @State var showsAlert = false
    private static var giftIdClicked: String = ""
    
    var body: some View {
        VStack {
            HStack{
                Spacer().frame(height: 20)
                .alert(isPresented: self.$showsAlert,
                       TextAlert(title: "Create gift voucher",
                                 placeholder: "Enter recipient name",
                                 accept: "Create",
                                 action: {
                                    if $0 != nil {
                                        let name = $0
                                        if name!.count > 2 {
                                            print("Create " + name! + " txn: " + TabProfile.giftIdClicked)
                                            ScraperManager.getInstance().create_voucher(transid: TabProfile.giftIdClicked, name: name!)
                                            return
                                        }
                                        self.showsAlert = true
                                    }
                                    else {
                                        print("Cancelled")
                                    }
                                 }
                    )
                )
            }
            VStack(alignment: .center){
                HStack(alignment: .top, spacing: 20) {
                    Button(action: {
                        let sm = ScraperManager.getInstance()
                        sm.logout()
                    } ) {
                        Image("logout")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30, alignment: .topTrailing)
                            .padding([.horizontal], 40.0)
                    }
                    AsyncImage(
                        url: URL(string: self.wp_user.user_avatar_url)!
                        ,
                        placeholder: Image("login_logo")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 120, maxWidth: 120, minHeight: 120,  maxHeight: 120, alignment: .center)
                        .padding(.bottom, 10.0)
                    ).aspectRatio(contentMode: .fit)
                    Button(action: {
                        ScraperManager.getInstance().notify(source: UpdateSource.navprofile,
                                                            requestview: RequestedView.settings,
                                                            loginstate: ScraperManager.login_status!,
                                                            payload: Payload(""),
                                                            error: ApiError("",""))
                    } ) {
                        Image("settings")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30, alignment: .topLeading)
                            .padding([.horizontal], 40.0)
                    }
                }
                Text(wp_user.display_name).bold().font(Common.UfontBoldXL)
                GaneshSpacer()
                
                // My Bookings
                Section("My bookings") {
                    RowStack(rows: self.bookings.bookings.count, empty: "You currently have no bookings") { row in
                        HStack(spacing: 5) {
                            Button(action: {
                                UIApplication.shared.open(URL(string: self.bookings.bookings[row].murl)!)
                            }){
                                Image("zoom").renderingMode(.original).resizable().frame(width: 32, height: 32, alignment: .trailing)
                            }.padding(.leading, 15).buttonStyle(ImageButton())
                            
                            if Common.isTimeReady(booking: self.bookings.bookings[row]) {
                                Button(action: {
                                    let sm = ScraperManager.getInstance()
                                    sm.open_door(class_id: self.bookings.bookings[row].class_id)
                                }){
                                    Image("door").renderingMode(.original).resizable().frame(width: 32, height: 32, alignment: .trailing)
                                }.padding(.trailing, 0).buttonStyle(ImageButton())
                            }                            
                        }.frame(alignment: .leading).padding(.trailing, 15)
                        VStack(){
                            Text(self.bookings.bookings[row].date).font(Common.Ufont14).fixedSize(horizontal: false, vertical: true).frame(width: 80, alignment: .leading).padding(.leading, 0)
                            Text(self.bookings.bookings[row].start_time).font(Common.Ufont14).fixedSize(horizontal: false, vertical: true).frame(width: 40, alignment: .leading).padding(.leading, 0)
                        }.padding(.trailing, 15)
                        Text(self.bookings.bookings[row].class_name).font(Common.Ufont14).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 0)
                    }
                }
                
                // Expiring credit
                Section("Expiring credit") {
                    RowStack(rows: self.expiring_credits.expiring_credits.count, empty: "Not available") { row in
                        HStack {
                            Text(self.expiring_credits.expiring_credits[row].num_tokens + "x")
                                .font(Common.Ufont12)
                                .frame(width: 30, alignment: .trailing)
                            Text(self.expiring_credits.expiring_credits[row].txn_id)
                                .font(Common.Ufont12)
                                .frame(width: 140, alignment: .leading)
                            Text(self.expiring_credits.expiring_credits[row].expiry_date)
                                .font(Common.Ufont12)
                                .frame(width: 70)
                            if self.expiring_credits.expiring_credits[row].class_type_restriction != "" {
                                Text(self.expiring_credits.expiring_credits[row].class_type_restriction)
                                    .font(Common.Ufont12)
                                    .frame(minWidth: 40, maxWidth: .infinity)
                            } else {
                                Text("Standard")
                                    .font(Common.Ufont12)
                                    .frame(minWidth: 40, maxWidth: .infinity)
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .background(row % 2 > 0 ? Color(hex: 0xEEEEEE) : Color(hex: 0xFFFFFF, alpha: 0.0))
                    }
                }
                
                // Used credit
                Section("Used credit") {
                    RowStack(rows: self.used_credits.used_credits.count, empty: "You have no used credits") { row in
                        HStack {
                            Text(self.used_credits.used_credits[row].num_tokens + "x")
                                .font(Common.Ufont12)
                                .frame(width: 30, alignment: .trailing)
                            Text(self.used_credits.used_credits[row].txn_id)
                                .font(Common.Ufont12)
                                .frame(width: 140, alignment: .leading)
                            Text(self.used_credits.used_credits[row].expiry_date)
                                .font(Common.Ufont12)
                                .frame(width: 70)
                            if self.used_credits.used_credits[row].class_type_restriction != "" {
                                Text(self.used_credits.used_credits[row].class_type_restriction)
                                    .font(Common.Ufont12)
                                    .frame(minWidth: 40, maxWidth: .infinity)
                            } else {
                                Text("Standard")
                                    .font(Common.Ufont12)
                                    .frame(minWidth: 40, maxWidth: .infinity)
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .background(row % 2 > 0 ? Color(hex: 0xEEEEEE) : Color(hex: 0xFFFFFF, alpha: 0.0))
                    }
                }
                
                // Transaction history
                Section("Transaction history") {
                    RowStack(rows: self.transactions.transactions.count, empty: "You have no transaction history") { row in
                        HStack {
                            Text(self.transactions.transactions[row].purchase_date)
                                .font(Common.Ufont12)
                                .frame(width: 80)
                                .padding(.leading, 5)
                            VStack {
                                Text(self.transactions.transactions[row].txn_id)
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(self.transactions.transactions[row].first_name + " " + self.transactions.transactions[row].last_name)
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(self.transactions.transactions[row].payer_email)
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            VStack {
                                Text(self.transactions.transactions[row].purchase_amount)
                                    .font(Common.Ufont12)
                                    .frame(minWidth: 20)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                Text(self.transactions.transactions[row].pname)
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(minWidth: 20)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                            Button(action: {
                                let sm = ScraperManager.getInstance()
                                sm.download_receipt(id: self.transactions.transactions[row].id)
                            }) {
                                Image("receipt")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 5)
                            }.buttonStyle(ImageButton())
                            if self.transactions.transactions[row].used_tokens == "0" {
                                Button(action: {
                                    TabProfile.giftIdClicked = self.transactions.transactions[row].id
                                    self.showsAlert = true
                                }) {
                                    Image("gift")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 10)
                                }
                                .buttonStyle(ImageButton())
                            }
                            else {
                                Text("")
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 10)
                            }
                            
                        }.background(row % 2 > 0 ? Color(hex: 0xEEEEEE) : Color(hex: 0xFFFFFF, alpha: 0.0))
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    }
                }
            }
        }
    }
}
