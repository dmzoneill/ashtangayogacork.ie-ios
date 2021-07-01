//
//  tab_profile.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

struct TabClasses: View {
    @ObservedObject var credits = ScraperManager.get_profile().credits
    @ObservedObject var bookings = ScraperManager.get_bookings()
    @ObservedObject var classes = ScraperManager.get_classes()
    @State private var monthlyAlert = false
    @State var showsAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(height: 20)
                    .alert(isPresented: self.$showsAlert,
                           TextAlert(title: "Redeem Code",
                                     placeholder: "Enter code",
                                     accept: "Redeem",
                                     action: {
                                        if $0 != nil {
                                            let code = $0
                                            if code!.count > 4 {
                                                print("Redeem code: " + code!)
                                                ScraperManager.getInstance().apply_redeem_code(code: code!)
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
            VStack(alignment: .center) {
                // Available Class Credit
                Section("Available Class Credit") {
                    VStack {
                        HStack {
                            Text(self.credits.credits.credits_available)
                                .font(Common.headerLetterFont)
                                .foregroundColor(Color.red)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                .fixedSize(horizontal: false, vertical: true)
                            if self.credits.credits.available_monthlys != 0  {
                                Button(action: {
                                    self.monthlyAlert = true
                                }){
                                    Text("Activate Monthly")
                                        .font(Common.Ufont12Bold)
                                }
                                .alert(isPresented:self.$monthlyAlert) {
                                    return Alert(title: Text("Activate monthly"),
                                                 message: Text("Are you sure you want to activate your monthly"),
                                                 primaryButton: .destructive(Text("Activate")) {
                                                     ScraperManager.getInstance().begin_monthly();
                                                 },
                                                 secondaryButton: .cancel())
                                }
                                .buttonStyle(GradientBackgroundStyle())
                                .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 10))
                            }
                            Button(action: {
                                self.showsAlert = true
                            }){
                                Text("Redeem code")
                                    .font(Common.Ufont12Bold)
                            }.buttonStyle(GradientBackgroundStyle())
                                .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 10))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                        }.frame(alignment: .leading)
                                                
                        RowStack(rows: self.credits.credits.credit_types.count, empty: "") { row in
                            HStack(spacing: 10) {
                                Text(self.credits.credits.credit_types[row][1])
                                    .font(Common.Ufont12Bold)
                                    .foregroundColor(Color.red)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(alignment: .leading)
                                    .padding(EdgeInsets(top: 5, leading: 25, bottom: 5, trailing: 0))
                                Text(self.credits.credits.credit_types[row][0])
                                    .font(Common.Ufont12Bold)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                            }.frame(alignment: .leading)
                        }.frame(alignment: .leading)
                    }.frame(alignment: .leading)
                }
                
                // My bookings
                Section("My bookings") {
                    RowStack(rows: self.bookings.bookings.count, empty: "You currently have no bookings") { row in
                        HStack(spacing: 5) {
                            Button(action: {
                                UIApplication.shared.open(URL(string: self.bookings.bookings[row].murl)!)
                            }){
                                Image("zoom").renderingMode(.original).resizable().frame(width: 32, height: 32, alignment: .trailing)
                            }.padding(.trailing, 0).buttonStyle(ImageButton())
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
                
                // Workshops & events
                Section("Workshops & events") {
                    RowStack(rows: self.classes.sticky_classes.count, empty: "No events scheduled") { row in
                        VStack(spacing: 0) {
                            if row == 0 {
                                WeekRule("Week " + self.classes.sticky_classes[row].week)
                                HorizontalRule()
                                DateRule(self.classes.sticky_classes[row].date)
                            }
                            if row > 0 {
                                if self.classes.sticky_classes[row].week != self.classes.sticky_classes[row-1].week {
                                    WeekRule("Week " + self.classes.sticky_classes[row].week)
                                    HorizontalRule()
                                }
                                if self.classes.sticky_classes[row].date != self.classes.sticky_classes[row-1].date {
                                    DateRule(self.classes.sticky_classes[row].date)
                                }
                            }
                            HStack(spacing: 0){
                                VStack{
                                    Text(self.classes.sticky_classes[row].start_time).font(Common.Ufont14Bold).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10))
                                    Text(self.classes.sticky_classes[row].end_time).font(Common.Ufont14Bold).padding(EdgeInsets(top: 2, leading: 10, bottom: 8, trailing: 10))
                                }.frame(width: 60, alignment: .leading)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(self.classes.sticky_classes[row].name).font(Common.Ufont14Bold).fixedSize(horizontal: false, vertical: true)
                                    HStack {
                                        Text("Teacher: ").font(Common.Ufont12).fixedSize(horizontal: false, vertical: true)
                                        Text(self.classes.sticky_classes[row].instructor).font(Common.Ufont12Bold).fixedSize(horizontal: false, vertical: true)
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                BookButton(self, self.classes.sticky_classes[row])
                            }
                        }
                    }
                }
 
                // Standard class credit
                Section("Schedule") {
                    RowStack(rows: self.classes.classes.count, empty: "No classes scheduled") { row in
                        VStack(spacing: 0) {
                            if row == 0 {
                                WeekRule("Week " + self.classes.classes[row].week)
                                HorizontalRule()
                                DateRule(self.classes.classes[row].date)
                            }
                            if row > 0 {
                                if self.classes.classes[row].week != self.classes.classes[row-1].week {
                                    WeekRule("Week " + self.classes.classes[row].week)
                                    HorizontalRule()
                                }
                                if self.classes.classes[row].date != self.classes.classes[row-1].date {
                                    DateRule(self.classes.classes[row].date)
                                }
                            }
                            HStack(spacing: 0){
                                VStack{
                                    Text(self.classes.classes[row].start_time).font(Common.Ufont14Bold).padding(EdgeInsets(top: 8, leading: 10, bottom: 2, trailing: 10))
                                    Text(self.classes.classes[row].end_time).font(Common.Ufont14Bold).padding(EdgeInsets(top: 2, leading: 10, bottom: 8, trailing: 10))
                                }.frame(width: 60, alignment: .leading)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(self.classes.classes[row].name).font(Common.Ufont14Bold).fixedSize(horizontal: false, vertical: true)
                                    HStack {
                                        Text("Teacher: ").font(Common.Ufont12).fixedSize(horizontal: false, vertical: true)
                                        Text(self.classes.classes[row].instructor).font(Common.Ufont12Bold).fixedSize(horizontal: false, vertical: true)
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                BookButton(self, self.classes.classes[row])
                            }
                        }
                    }
                }
            }
        }
    }
}
