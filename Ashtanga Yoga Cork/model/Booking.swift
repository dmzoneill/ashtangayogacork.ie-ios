//
//  Booking.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 21/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation


class Booking : ObservableObject {
    @Published var id: String = ""
    @Published var class_id: String = ""
    @Published var date: String = ""
    @Published var start_time: String = ""
    @Published var end_time: String = ""
    @Published var class_name: String = ""
    @Published var instructor_name: String = ""
    @Published var murl: String = ""
    @Published var doorArmedBeforeMins: String = ""
    @Published var doorDisarmedAfterMins: String = ""

    init(
        id: String,
        class_id: String,
        date: String,
        start_time: String,
        end_time: String,
        class_name: String,
        instructor_name: String,
        murl: String,
        doorArmedBeforeMins: String,
        doorDisarmedAfterMins: String
    ) {
        self.id = id
        self.class_id = class_id
        self.date = date
        self.start_time = start_time
        self.end_time = end_time
        self.class_name = class_name
        self.instructor_name = instructor_name
        self.murl = murl
        self.doorArmedBeforeMins = doorArmedBeforeMins
        self.doorDisarmedAfterMins = doorDisarmedAfterMins
    }
}

class Bookings: ObservableObject {
    @Published var bookings: [Booking] = [Booking]()
}
