//
//  BookButton.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 25/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct BookButton: View {
    @ObservedObject var credits = ScraperManager.get_profile().credits
    @State private var showingAlert = false
    @State var alertType: Int = 0
    var parent: TabClasses
    var classRef: Class
    
    var body: some View {
        Button(action: {
            if self.classRef.book_button_action == "ButtonBook" {
                if self.classRef.disabled {
                    self.alertType = 2
                    self.showingAlert = true
                    return;
                }
                if self.credits.credits.credits_available == "0" && self.classRef.free == false {
                    print("no credits, not free")
                    self.alertType = 1
                    self.showingAlert = true
                    return;
                }
                if self.classRef.cancellation_warning {
                    print("button cancellation warning")
                    self.alertType = 0
                    self.showingAlert = true
                    return;
                }
                self.book_confirm()
            }
            else if self.classRef.book_button_action == "ButtonCancel" {
                if self.classRef.disabled {
                    print("button disabled")
                    self.alertType = 3
                    self.showingAlert = true
                    return;
                }
                if self.classRef.cancellation_warning {
                    print("button cancellation warning")
                    self.alertType = 4
                    self.showingAlert = true
                    return;
                }
                self.book_cancel()
            }
            else if self.classRef.book_button_action == "ButtonTimePassed" {
                print("button disabled")
                self.alertType = 4
                self.showingAlert = true
                return;
            }
            else {
                print("here")
                print(self.classRef.book_button_action)
            }
        }){
            if self.classRef.book_button_action == "ButtonBook" {
                Text(self.classRef.button_text)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Common.Ufont12Bold)
            }
            else if self.classRef.book_button_action == "ButtonPurchase" {
                Text("Purchase to book")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Common.Ufont12Bold)
            }
            else if self.classRef.book_button_action == "ButtonTimePassed" {
                Text("Cancellation passed")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Common.Ufont12Bold)
            }
            else if self.classRef.book_button_action == "ButtonCancel" {
                Text("Cancel booking")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Common.Ufont12Bold)
            }
            else {
                Text(self.classRef.button_text)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Common.Ufont12Bold)
                    
            }
        }
        .buttonStyle(GradientBackgroundStyle())
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
        //.frame(minWidth: 0, maxWidth: 120, minHeight: 0, maxHeight: 80, alignment: .center)
        .alert(isPresented:$showingAlert) {
            var confirm_title = ""
            var confirm_message = ""
            var confirm_button = ""
            
            if alertType == 0 {
                confirm_title = "Booking Cancellation"
                confirm_message = "This booking cannot be cancelled, are you sure you want to book?"
                confirm_button = "Book"
            }
            
            if alertType == 1 {
                confirm_title = "Purchase to book"
                confirm_message = "You have no available credits to book, please purchase"
                confirm_button = "Okay"
            }
            
            if alertType == 2 {
                confirm_title = "Unable to book"
                confirm_message = "You are unable to book this class"
                confirm_button = "Okay"
            }
            
            if alertType == 3 {
                confirm_title = "Unable to cancel"
                confirm_message = "You are unable to cancel this booking"
                confirm_button = "Okay"
            }
            
            if alertType == 4 {
                confirm_title = "Cancellation time passed"
                confirm_message = "You are unable to cancel this booking as the cancellation has passed"
                confirm_button = "Okay"
            }
            
            if alertType == 0 {
                return Alert(title: Text(confirm_title),
                         message: Text(confirm_message),
                         primaryButton: .destructive(Text(confirm_button)) {
                                self.book_confirm()
                         },
                         secondaryButton: .cancel())
            }
            
            return Alert(title: Text(confirm_title),
                         message: Text(confirm_message),
                         dismissButton: Alert.Button.default(Text("Okay"), action:
                         {
                            return
                         }
                    )
                )
        }
    }
    
    private func book_confirm() {
        let sm: ScraperManager = ScraperManager.getInstance()
        sm.book_class_add(class_id: self.classRef.class_id)
    }
    
    private func book_cancel() {
        let sm: ScraperManager = ScraperManager.getInstance()
        sm.book_class_remove(class_id: self.classRef.class_id)
    }
    
    init(_ parent: TabClasses, _ classRef: Class) {
        self.parent = parent
        self.classRef = classRef
    }
}
