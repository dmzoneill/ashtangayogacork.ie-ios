//
//  tab_prices.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI



struct TabPrices: View {
    @ObservedObject var prices = ScraperManager.get_prices()
        
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer().frame(height: 20)
            }
                
            // Yoga For Everyone
            Section("Yoga for everyone") {
                Text("You won't find our level of service any where else in Cork!  Our prices are competitve for the level of student-teacher interaction you will receive.\n\nIn our classes, the teacher will get to know you personaly and work with you to develop your own practice.\n\nWe use paypal for all transactions. You do not require a paypal account to use paypal and our services. Paypal accepts all major credits cards and debit cards while providing you with ease, assurement and security.\n\nYou can also call or email us for more information. Refer to the classes pages for bookings.").font(Common.Ufont14).fixedSize(horizontal: false, vertical: true)
            }
                
            // Gift Vouchers
            Section("Vouchers/Gifts") {
                Text("All purchase options below can be gifted to an individual or a loved one.  Purchase as normal and then visit the profile page and gift the transaction.").font(Common.Ufont14).fixedSize(horizontal: false, vertical: true)
            }
                
            // Monthlies
            Section("Monthlies") {
                VStack(alignment: .leading) {
                    if self.prices.monthlies_prices.count > 0 {
                        Text("* 1 credit = 1 class")
                            .font(Common.Ufont12)
                            .fixedSize(horizontal: false, vertical: true).padding(.leading, 5)
                    }
                    RowStack(rows: self.prices.monthlies_prices.count, empty: "Currently not available, contact us for more information") { row in
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(self.prices.monthlies_prices[row].name)
                                    .font(Common.Ufont14Bold)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("This credit is for standard mysore and led classes.")
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("You will receive " + self.prices.monthlies_prices[row].credits + " credits and they are valid for " + self.prices.monthlies_prices[row].credit_expiry)
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                            }.frame(maxWidth: .infinity).padding(5)
                            Text("€" + self.prices.monthlies_prices[row].price)
                                .font(Common.Ufont14Bold)
                                .frame(width:50)
                            Button(action: {
                                BuyView.viewModel.paypalid = self.prices.monthlies_prices[row].paypal_button_code
                                let sm = ScraperManager.getInstance();
                                sm.notify(source: UpdateSource.navprices, requestview: RequestedView.purchase, loginstate: ScraperManager.login_status!, payload: Payload( ""), error: ApiError("",""))
                            }){
                                Image("paypal_checkout_narrow")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 100, height: 55, alignment: .trailing)
                                }
                                .buttonStyle(PayPalButton())
                        }.frame(maxWidth: .infinity)
                    }
                    if self.prices.monthlies_prices.count > 0 {
                        Text("¹ Multiple monthlies can be bought and can be activated at a later stage")
                            .font(Common.Ufont12)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(EdgeInsets(top: 15, leading: 5, bottom: 5, trailing: 5))
                        Text("² Some monthlies are limited in the amount of times you can purchase it")
                            .font(Common.Ufont12)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 5)
                    }
                }
            }
            
            // Specials
            Section("Specials") {
                VStack(alignment: .leading) {
                    if self.prices.special_prices.count > 0 {
                        Text("* 1 credit = 1 class").font(Common.Ufont12).fixedSize(horizontal: false, vertical: true).padding(.leading, 5)
                    }
                    RowStack(rows: self.prices.special_prices.count, empty: "Currently not available, contact us for more information") { row in
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(self.prices.special_prices[row].name)
                                    .font(Common.Ufont14Bold)
                                    .fontWeight(.heavy)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("You will receive " + self.prices.special_prices[row].credits + " credits and it is valid for this class only")
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                            }.frame(maxWidth: .infinity).padding(5)
                            Text("€" + self.prices.special_prices[row].price)
                                .font(Common.Ufont14Bold)
                                .frame(width:50)
                            Button(action: {
                                BuyView.viewModel.paypalid = self.prices.special_prices[row].paypal_button_code
                                let sm = ScraperManager.getInstance();
                                sm.notify(source: UpdateSource.navprices, requestview: RequestedView.purchase, loginstate: ScraperManager.login_status!, payload: Payload( ""), error: ApiError("",""))
                            }){
                                Image("paypal_checkout_narrow")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 100, height: 55, alignment: .trailing)
                                }
                                .buttonStyle(PayPalButton())
                        }.frame(maxWidth: .infinity)
                    }
                }
            }
            
            // Standard class credit
            Section("Standard Class Credit") {
                VStack(alignment: .leading) {
                    if self.prices.standard_prices.count > 0 {
                        Text("* 1 credit = 1 class").font(Common.Ufont12).fixedSize(horizontal: false, vertical: true).padding(.leading, 5).padding(2)
                        Text("* Valid from the date of purchase").font(Common.Ufont12).fixedSize(horizontal: false, vertical: true).padding(.leading, 5).padding(2)
                    }
                    RowStack(rows: self.prices.standard_prices.count, empty: "Currently not available, contact us for more information") { row in
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(self.prices.standard_prices[row].name)
                                    .font(Common.Ufont14Bold)
                                    .fontWeight(.heavy)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("This credit is for standard mysore and led classes.")
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("You will receive " + self.prices.standard_prices[row].credits + " credits and they are valid for " + self.prices.standard_prices[row].credit_expiry)
                                    .font(Common.Ufont12)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.frame(maxWidth: .infinity).padding(5)
                            Text("€" + self.prices.standard_prices[row].price)
                                .font(Common.Ufont14Bold)
                                .frame(width:50)
                            Button(action: {
                                BuyView.viewModel.paypalid = self.prices.standard_prices[row].paypal_button_code
                                let sm = ScraperManager.getInstance();
                                sm.notify(source: UpdateSource.navprices, requestview: RequestedView.purchase, loginstate: ScraperManager.login_status!, payload: Payload( ""), error: ApiError("",""))
                            }){
                                Image("paypal_checkout_narrow")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 100, height: 55, alignment: .trailing)
                                }
                                .buttonStyle(PayPalButton())
                                
                        }.frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

