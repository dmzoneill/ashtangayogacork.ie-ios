//
//  Class.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation

class Class : ObservableObject {
    @Published var class_id: String = ""
    @Published var week: String = ""
    @Published var date: String = ""
    @Published var start_time: String = ""
    @Published var end_time: String = ""
    @Published var name: String = ""
    @Published var instructor: String = ""
    @Published var class_instructor: String = ""
    @Published var cancellation_warning: Bool = false
    @Published var book_button_action: String = ""
    @Published var first_booking_frequency: String = ""
    @Published var first_booking_title: String = ""
    @Published var first_booking_message: String = ""
    @Published var free: Bool = false
    @Published var max_attendees: String = ""
    @Published var class_quota: Int = 0
    @Published var class_type: String = ""
    @Published var description: String = ""
    @Published var disabled: Bool = false
    @Published var button_text: String = ""
    @Published var waitlist: String = ""
    @Published var token_restriction: String = ""
    @Published var sticky: String = ""
    
    init(
        class_id: String,
        week: String,
        date: String,
        start_time: String,
        end_time: String,
        name: String,
        instructor: String,
        class_instructor: String,
        cancellation_warning: Bool,
        book_button_action: String,
        first_booking_frequency: String,
        first_booking_title: String,
        first_booking_message: String,
        free: Bool,
        max_attendees: String,
        class_quota: Int,
        class_type: String,
        description: String,
        disabled: Bool,
        button_text: String,
        waitlist: String,
        token_restriction: String,
        sticky: String    
    ){
        self.class_id = class_id
        self.week = week
        self.date = date
        self.start_time = start_time
        self.end_time = end_time
        self.name = name
        self.instructor = instructor
        self.class_instructor = class_instructor
        self.cancellation_warning = cancellation_warning
        self.book_button_action = book_button_action
        self.first_booking_frequency = first_booking_frequency
        self.first_booking_title = first_booking_title
        self.first_booking_message = first_booking_message
        self.free = free
        self.max_attendees = max_attendees
        self.class_quota = class_quota
        self.class_type = class_type
        self.description = description
        self.disabled = disabled
        self.button_text = button_text
        self.waitlist = waitlist
        self.token_restriction = token_restriction
        self.sticky = sticky
    }
}

class Classes: ObservableObject {
    @Published var classes: [Class] = [Class]()
    @Published var sticky_classes: [Class] = [Class]()
}
