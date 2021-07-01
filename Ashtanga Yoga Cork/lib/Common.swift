//
//  Common.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 23/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI

class Common {        
    public static let headerLetterFont = Font.custom("JosefinSans-Thin_Bold", size: 32)
    public static let headerRemainderFont = Font.custom("JosefinSans-Thin_Bold", size: 24)
    
    public static let Ufont12 = Font.custom("Ubuntu", size: 12)
    public static let Ufont12Bold = Font.custom("Ubuntu-Bold", size: 12)
    
    public static let Ufont14 = Font.custom("Ubuntu", size: 14)
    public static let Ufont14Bold = Font.custom("Ubuntu-Bold", size: 14)
    
    public static let Ufont16 = Font.custom("Ubuntu", size: 16)
    public static let Ufont16Bold = Font.custom("Ubuntu-Bold", size: 16)
    
    public static let UfontBoldML = Font.custom("Ubuntu-Bold", size: 26)
    public static let UfontBoldXL = Font.custom("Ubuntu-Bold", size: 32)
    
    public static func isTimeReady(booking: Booking) -> Bool {
        let cdate = booking.date;
        let ctime = booking.start_time;
        let timestr = cdate + " " + ctime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        let date2 = Date()
        
                
        if let date1 = dateFormatter.date(from: timestr) {
            let now = Int(date2.timeIntervalSince1970);
            
            let doorArmedBeforeSeconds = Int(booking.doorArmedBeforeMins)! * 60;
            let doorDisarmedBeforeSeconds = Int(booking.doorDisarmedAfterMins)! * 60;
            
            let start = Int(date1.timeIntervalSince1970) - doorArmedBeforeSeconds
            let stop = Int(date1.timeIntervalSince1970) + doorDisarmedBeforeSeconds
                        
            print("start : " + String(start))
            print("now   : " + String(now))
            print("stop  : " + String(stop))
            
            if now > start && now < stop {
                return true
            }
        }
        
        return false
    }
}
