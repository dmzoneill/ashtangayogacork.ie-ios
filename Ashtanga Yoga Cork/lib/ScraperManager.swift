//
//  ScraperManager.swift
//  Ashtanga Yoga Cork
//
//  Created by Dave on 09/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit
import UIKit

class ScraperManager: Observable {
    
    private static var cookieStore: [String: String] = [:]
    private static var observers: [Observer]? = nil
    private static var instance: ScraperManager? = nil
    private static let config = URLSessionConfiguration.default
    
    private static var profile: Profile = Profile(w:  WP_user(), s: Student(), c: Credits())
    private static var classes: Classes = Classes()
    private static var prices: Prices = Prices()
    private static var bookings: Bookings = Bookings()
    private static var transactions: Transactions = Transactions()
    private static var used_credits: Used_credits = Used_credits()
    private static var expiring_credits: Expiring_credits = Expiring_credits()
    public static var login_status: LoginStatus? = nil

    private init() {
        
        let defaults = UserDefaults.standard
        ScraperManager.cookieStore = defaults.object(forKey: "cookieStore") as? [String:String] ?? [String:String]()
        
        if(ScraperManager.observers == nil) {
            ScraperManager.observers = [Observer]()
        }
    }

    public static func getInstance() -> ScraperManager {
        ScraperManager.config.httpCookieAcceptPolicy = .never
        if(ScraperManager.instance == nil) {
            ScraperManager.instance = ScraperManager()
        }
        return ScraperManager.instance!
    }
    
    public static func get_profile() -> Profile {
        return ScraperManager.profile
    }
    
    public static func get_classes() -> Classes {
        return ScraperManager.classes
    }
    
    public static func get_prices() -> Prices {
        return ScraperManager.prices
    }
    
    public static func get_bookings() -> Bookings {
        return ScraperManager.bookings
    }
    
    public static func get_transactions() -> Transactions {
        return ScraperManager.transactions
    }
    
    public static func get_used_credits() -> Used_credits {
        return ScraperManager.used_credits
    }
    
    public static func get_expiring_credits() -> Expiring_credits {
        return ScraperManager.expiring_credits
    }
    
    private func save_cookies(response: HTTPURLResponse) -> Void {
        let defaults = UserDefaults.standard
        let fields = response.allHeaderFields as? [String :String]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields!, for: response.url!)

        for cookie in cookies {
            ScraperManager.cookieStore[cookie.name] = cookie.value
            print("name: \(cookie.name) value: \(cookie.value)")
        }
        
        defaults.set(ScraperManager.cookieStore, forKey: "cookieStore")
    }
    
    public func add_social_cookies(cookie: HTTPCookie) -> Void {
        let defaults = UserDefaults.standard
        ScraperManager.cookieStore[cookie.name] = cookie.value
        print("name: \(cookie.name) value: \(cookie.value)")
        defaults.set(ScraperManager.cookieStore, forKey: "cookieStore")
    }
    
    public func get_cookies() -> String {
        var cookies: String = ""
        for cookie in ScraperManager.cookieStore {
            cookies = cookie.key + "=" + cookie.value + ";" + cookies
        }
        return cookies
    }
    
    public static func get_cookies_array() -> [String: String] {
        return ScraperManager.cookieStore
    }
    
    public func clear_cookies() -> Void {
        let defaults = UserDefaults.standard
        ScraperManager.cookieStore = [String:String]()
        defaults.set(ScraperManager.cookieStore, forKey: "cookieStore")
    }
    
    public func logout() -> Void {
        self.clear_cookies()
        ScraperManager.login_status = LoginStatus(a: "check_logged_in", r: false, e: "logged out")
        DispatchQueue.main.async {
            self.notify(source: UpdateSource.scraper,
                        requestview: RequestedView.login,
                        loginstate: ScraperManager.login_status!,
                        payload: Payload(""),
                        error: ApiError("",""))
        }
    }
    
    public func fetch_async(action: String, postfields: String) -> Void {
        let baseurl = "https://ashtangayoga.ie/json/?a="
        let request_url = baseurl + action
        let url = URL(string: request_url)
        var result: String = ""
        var request = URLRequest(url: url!)
        if(postfields.count > 0) {
            request.httpMethod = "POST"
            request.httpBody = postfields.data(using: String.Encoding.utf8);
        }
        
        let config = ScraperManager.config
        config.httpAdditionalHeaders = [
            "Host" : "ashtangayoga.ie",
            "User-Agent" : "ayc-ios/1.0",
            "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Connection": "keep-alive",
            "charset": "utf-8",
            "REFERER": "https://ashtangayoga.ie/wp-login.php",
            "Cookie": self.get_cookies()
        ]
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) {(data, response, error) in
            guard let realResponse = response as? HTTPURLResponse, realResponse.statusCode == 200 else {
                DispatchQueue.main.sync {
                    print("Not a 200 response")
                    ScraperManager.login_status = LoginStatus(a: "check_logged_in", r: false, e: "login failed")
                    self.notify(source: UpdateSource.scraper,
                                requestview: RequestedView.login,
                                loginstate: ScraperManager.login_status!,
                                payload: Payload(""),
                                error: ApiError("Login failed","The login attempt failed")
                    )
                }
                
                return
            }
            self.save_cookies(response: realResponse)
            result = String(data:data!, encoding: String.Encoding.utf8)!
            //print(result)
            let resdata = Data(result.utf8)
            
            do {
                if let json = try JSONSerialization.jsonObject(with: resdata, options: []) as? [String: Any] {
                    let jaction: String = json["action"] as! String
                    let jresult = json["result"] ?? ""
                    let jerror = json["error"] as? String ?? ""
                     
                    if jerror != "" {
                        print("Sending error: " + jaction + ":" + jerror)
                        if ScraperManager.login_status != nil {
                            self.notify(source: UpdateSource.scraper,
                                        requestview: RequestedView.nochange,
                                        loginstate: ScraperManager.login_status!,
                                        payload: Payload(""),
                                        error: ApiError(jaction, jerror)
                            )
                            return
                        }
                    }
                    
                    switch jaction {
                        case "get_bookings":
                            self.parse_bookings(json: jresult)
                        case "get_prices":
                            self.parse_prices(json: jresult)
                        case "get_classes":
                            self.parse_classes(json: jresult)
                        case "get_profile":
                            self.parse_profile(json: jresult)
                        case "get_transactions":
                            self.parse_transactions(json: jresult)
                        case "get_used_credit":
                            self.parse_used_credit(json: jresult)
                        case "get_expiring_credit":
                            self.parse_expiring_credit(json: jresult)
                        case "add_booking", "cancel_booking", "begin_monthly", "redeem_code":
                            self.fetch_all()
                        case "check_logged_in":
                            self.parse_logged_in(action: jaction, result: jresult, error: jerror)
                        default:
                            return
                    }
                }
            } catch let parsingError {
                print(parsingError)
            }
        }
        task.resume()
    }
    
    public func fetch_all() {
        DispatchQueue.main.async {
            self.fetch_async(action: "get_profile", postfields: "")
            self.fetch_async(action: "get_transactions", postfields: "")
            self.fetch_async(action: "get_expiring_credit", postfields: "")
            self.fetch_async(action: "get_used_credit", postfields: "")
            self.fetch_async(action: "get_prices", postfields: "")
            self.fetch_async(action: "get_classes", postfields: "")
            self.fetch_async(action: "get_bookings", postfields: "")
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    public func save_settings() {
        print(ScraperManager.profile.student.phone)
        print(ScraperManager.profile.student.sms_alerts)
        print(ScraperManager.profile.student.email_alerts)
        var url = "update_settings&sphone="
        url += ScraperManager.profile.student.phone
        url += "&ssms=" + String(ScraperManager.profile.student.sms_alerts)
        url += "&smail=" + String(ScraperManager.profile.student.email_alerts)
        self.fetch_async(action: url, postfields: "")
    }
    
    public func download_receipt(id: String) -> Void {
        let baseurl = "https://ashtangayoga.ie/receipt/?id=" + id
        
        let url = URL(string: baseurl)
        let request = URLRequest(url: url!)
        
        let config = ScraperManager.config
        config.httpAdditionalHeaders = [
            "Host" : "ashtangayoga.ie",
            "User-Agent" : "ayc-ios/1.0",
            "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Connection": "keep-alive",
            "charset": "utf-8",
            "REFERER": "https://ashtangayoga.ie/wp-login.php",
            "Cookie": self.get_cookies()
        ]
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
                        
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let url = paths[0].appendingPathComponent("ayc-receipt-" + id + "-" + self.randomString(length: 8) + ".pdf")
            
            do {
                try data!.write(to: url, options: .atomic)
                print(data!)
                let dtc = DownloadTaskComplete(url, data!)
                self.notify(source: .scraper,
                            requestview: .receipt,
                            loginstate: ScraperManager.login_status!,
                            payload: Payload(dtc),
                            error: ApiError("",""))
                print("Downloaded pdf")
            } catch {
                print(error.localizedDescription)
            }
        }).resume()
    }
        
    public func create_voucher(transid: String, name: String) -> Void {
        let baseurl = "https://ashtangayoga.ie/json/?a=get_voucher&vid=" + transid + "&vname=" + name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url = URL(string: baseurl)
        let request = URLRequest(url: url!)
        
        let config = ScraperManager.config
        config.httpAdditionalHeaders = [
            "Host" : "ashtangayoga.ie",
            "User-Agent" : "ayc-ios/1.0",
            "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Connection": "keep-alive",
            "charset": "utf-8",
            "REFERER": "https://ashtangayoga.ie/wp-login.php",
            "Cookie": self.get_cookies()
        ]
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse, realResponse.statusCode == 200 else {
                print("Not a 200 response")
                return
            }
            self.save_cookies(response: realResponse)
            let result = String(data:data!, encoding: String.Encoding.utf8)!
            let resdata = Data(result.utf8)
            
            do {
                if let json = try JSONSerialization.jsonObject(with: resdata, options: []) as? [String: Any] {
                    let jresult = json["result"] as? String ?? ""
                    let jerror = json["error"] ?? ""
                    let dtc = DownloadTaskComplete(nil, nil, jresult)
                    self.notify(source: .scraper, requestview: .voucher, loginstate: ScraperManager.login_status!, payload: Payload( dtc), error: ApiError("",""))
                    print("Gifted")
                    print(jerror)
                    print(jresult)
                }
            } catch let parsingError {
                print(parsingError)
            }
        }).resume()
    }
    
    public func create_issue(title: String, description: String, user: String) {
        var titleEsc: String = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var descriptionEsc: String = description.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var userEsc: String = user.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        titleEsc = "&t=" + titleEsc
        descriptionEsc = "&d=" + descriptionEsc
        userEsc = "&i=ios&u=" + userEsc;
        let url = URL(string: "https://ashtangayoga.ie/json/?a=submit_issue" + titleEsc + descriptionEsc + userEsc)
        let request = URLRequest(url: url!)
                
        let config = ScraperManager.config
        config.httpAdditionalHeaders = [
            "Host" : "ashtangayoga.ie",
            "User-Agent" : "ayc-ios/1.0",
            "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Connection": "keep-alive",
            "charset": "utf-8",
            "REFERER": "https://ashtangayoga.ie/wp-login.php"
        ]
                
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let result: String = String(data:data!, encoding: String.Encoding.utf8)!
            guard let realResponse = response as? HTTPURLResponse, realResponse.statusCode == 200 else {                
                DispatchQueue.main.sync {
                    self.notify(
                        source: UpdateSource.scraper, requestview: RequestedView.bug, loginstate: ScraperManager.login_status!, payload: Payload( result), error: ApiError("",""))
                }
                return
            }
            DispatchQueue.main.sync {
                self.notify(
                    source: UpdateSource.scraper, requestview: RequestedView.bug, loginstate: ScraperManager.login_status!, payload: Payload( result), error: ApiError("",""))
            }
        }
        task.resume()
    }
    
    public func login(postfields: String) {
        ScraperManager.cookieStore = [:]
        let url = URL(string: "https://ashtangayoga.ie/wp-login.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        print(postfields)
                
        let config = ScraperManager.config
        config.httpAdditionalHeaders = [
            "Host" : "ashtangayoga.ie",
            "User-Agent" : "ayc-ios/1.0",
            "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Connection": "keep-alive",
            "charset": "utf-8",
            "REFERER": "https://ashtangayoga.ie/wp-login.php",
            "Content-Type": "application/x-www-form-urlencoded",
            "Content-Length": String(postfields.count)
        ]
                
        let session = URLSession(configuration: config)
        
        let task = session.uploadTask(with: request, from: postfields.data(using: String.Encoding.utf8)){(data, response, error) in
            guard let realResponse = response as? HTTPURLResponse, realResponse.statusCode == 200 else {
                DispatchQueue.main.sync {
                    print("Not a 200 response")
                    ScraperManager.login_status = LoginStatus(a: "check_logged_in", r: false, e: "The login attempt failed")
                    self.notify(
                        source: UpdateSource.scraper, requestview: RequestedView.login, loginstate: ScraperManager.login_status!, payload: Payload(""), error: ApiError("Login failed","The login attempt failed"))
                }
                return
            }
            
            DispatchQueue.main.sync {
                self.save_cookies(response: realResponse)
                self.fetch_async(action: "check_logged_in", postfields: "")
            }
        }
        task.resume()
    }
    
    public func begin_monthly() {
        self.fetch_async(action: "begin_monthly", postfields: "")
    }
    
    public func apply_redeem_code(code: String) {
        self.fetch_async(action: "redeem_code&code=" + code, postfields: "")
    }
    
    public func book_class_add(class_id: String) {
        print("book_class_add")
        self.fetch_async(action: "add_booking&id=actionButton" + class_id, postfields: "")
    }
    
    public func book_class_remove(class_id: String) {
        self.fetch_async(action: "cancel_booking&id=actionButton" + class_id, postfields: "")
    }
    
    public func open_door(class_id: String) {
        self.fetch_async(action: "open_door&id=" + class_id, postfields: "")
    }
    
    public func get_voucher_url(name: String, transid: String) {
        self.fetch_async(action: "get_voucher&vid=" + transid + "&vname=" + name, postfields: "")
    }
    
    public func update_user_settings(phone: String , sms: String, mail: String ) {
        self.fetch_async(action: "update_settings&sphone=" + phone + "&ssms=" + sms + "&smail=" + mail, postfields: "")
    }
    
    private func parse_profile(json: Any) -> Void {
        //print(json)
        
        if let profile_objs = json as? [AnyObject] {
            if let wp_user = profile_objs[0] as? Dictionary<String, AnyObject> {
                if let wp_user_data = wp_user["data"] as? Dictionary<String, AnyObject> {
                    
                    DispatchQueue.main.async {
                        ScraperManager.profile.wp_user.ID = wp_user_data["ID"] as! String
                        ScraperManager.profile.wp_user.user_login = wp_user_data["user_login"] as! String
                        ScraperManager.profile.wp_user.user_pass = wp_user_data["user_pass"] as! String
                        ScraperManager.profile.wp_user.user_nicename = wp_user_data["user_nicename"] as! String
                        ScraperManager.profile.wp_user.user_email = wp_user_data["user_email"] as! String
                        ScraperManager.profile.wp_user.user_url = wp_user_data["user_url"] as! String
                        ScraperManager.profile.wp_user.user_registered = wp_user_data["user_registered"] as! String
                        ScraperManager.profile.wp_user.user_activation_key = wp_user_data["user_activation_key"] as! String
                        ScraperManager.profile.wp_user.user_status = wp_user_data["user_status"] as! String
                        ScraperManager.profile.wp_user.display_name = wp_user_data["display_name"] as! String
                        ScraperManager.profile.wp_user.user_avatar_url = wp_user_data["user_avatar_url"] as! String
                        self.notify(source: UpdateSource.scraper, requestview: RequestedView.navprofile, loginstate: ScraperManager.login_status!, payload: Payload( ""), error: ApiError("",""))
                    }
                }
            }
            if let user_profile = profile_objs[1] as? Dictionary<String, AnyObject> {
                DispatchQueue.main.async {
                    
                    var ebool = false
                    var sbool = false
                    let emailalert = user_profile["email_alerts"] as! String
                    let smsalerts = user_profile["sms_alerts"] as! String
                    print(smsalerts)
                    print(emailalert)
                    
                    if( emailalert == "1"){
                        ebool = true
                    }
                    
                    if( smsalerts == "1"){
                        sbool = true
                    }
                    
                    ScraperManager.profile.student.phone = user_profile["phone"] as! String
                    ScraperManager.profile.student.sms_alerts = sbool
                    ScraperManager.profile.student.email_alerts = ebool
                    
                    self.notify(source: UpdateSource.scraper,
                                requestview: RequestedView.navprofile,
                                loginstate: ScraperManager.login_status!,
                                payload: Payload( ""),
                                error: ApiError("",""))
                }
            }
            if let user_credit = profile_objs[2] as? Dictionary<String, AnyObject> {
                DispatchQueue.main.async {
                    let monthlies = user_credit["available_monthlys"] as! Int
                    ScraperManager.profile.credits.credits.credits_available = user_credit["credits_available"] as! String
                    ScraperManager.profile.credits.credits.available_monthlys = Int(monthlies)
                    ScraperManager.profile.credits.credits.credit_types.removeAll();
                    
                    if let credit_types = user_credit["credit_type"] as? Dictionary<String, String> {
                        for (key,value) in credit_types {
                            if key == "availableStandardCredits" {
                                ScraperManager.profile.credits.credits.credit_types.append(["Standard credits",value])
                            }
                            else {
                                ScraperManager.profile.credits.credits.credit_types.append([key,value])
                            }
                        }
                    }
                    self.notify(source: UpdateSource.scraper,
                                requestview: RequestedView.navprofile,
                                loginstate: ScraperManager.login_status!,
                                payload: Payload( ""),
                                error: ApiError("",""))
                }
            }
        }
    }
    
    private func parse_transactions(json: Any) -> Void {
        //print(json)
        
        if let transaction_objs = json as? [AnyObject] {
            DispatchQueue.main.async {
                ScraperManager.transactions.transactions.removeAll()
                for tn in transaction_objs as! [Dictionary<String, AnyObject>] {
                    var class_type_restriction: String = ""
                    if let value = tn["class_type_restriction"] as? String {
                        class_type_restriction = value
                    }
                    
                    var rname: String = ""
                    if let value = tn["rname"] as? String {
                        rname = value
                    }
                    
                    var pname: String = ""
                    if let value = tn["pname"] as? String {
                        pname = value.decodeUrl()!
                    }
                    
                    var payer_email = tn["payer_email"] as! String
                    payer_email = payer_email.decodeUrl()!
                    var first_name = tn["first_name"] as! String
                    first_name = first_name.decodeUrl()!
                    var last_name = tn["last_name"] as! String
                    last_name = last_name.decodeUrl()!
                    
                    let transact_obj = Transaction(
                                                id: tn["id"] as! String,
                                                pn: pname,
                                                pd: tn["purchase_date"] as! String,
                                                pa: tn["purchase_amount"] as! String,
                                                ct: class_type_restriction,
                                                rn: rname,
                                                pe: payer_email,
                                                tx: tn["txn_id"] as! String,
                                                fn: first_name,
                                                ln: last_name,
                                                ut: tn["used_tokens"] as! String)
                                
                    ScraperManager.transactions.transactions.append(transact_obj)
                }
            }
        }
    }
    
    private func parse_expiring_credit(json: Any) -> Void {
        //print(json)
        
        if let expiring_credit_objs = json as? [AnyObject] {
            DispatchQueue.main.async {
                ScraperManager.expiring_credits.expiring_credits.removeAll()
                if let eco = expiring_credit_objs[1] as? Dictionary<String, [AnyObject]> {
                    for (key, value) in eco {
                        var class_type_restriction: String = ""
                        if let value = value[1] as? String {
                            class_type_restriction = value
                        }
                        let parts = key.components(separatedBy: "#")
                        let ed = value[0] as? String ?? ""
                        let nt = value[2] as? String ?? ""
                        let credit = Expiring_credit(id: parts[0], pd: parts[1], ed: ed, ctr: class_type_restriction, nt: nt)
                        ScraperManager.expiring_credits.expiring_credits.append(credit)
                    }
                }
            }
        }
    }
    
    private func parse_used_credit(json: Any) -> Void {
        //print(json)
        
        if let used_credit_objs = json as? [AnyObject] {
            DispatchQueue.main.async {
                ScraperManager.used_credits.used_credits.removeAll()
                if let uco = used_credit_objs[1] as? Dictionary<String, [AnyObject]> {
                    for (key, value) in uco {
                        var class_type_restriction: String = ""
                        if let rvalue = value[1] as? String {
                            class_type_restriction = rvalue
                        }
                        let parts = key.components(separatedBy: "#")
                        let ed = value[0] as? String ?? ""
                        let nt = value[2] as? String ?? ""
                        let credit = Used_credit(id: parts[0], pd: parts[1], ed: ed, ctr: class_type_restriction, nt: nt)
                        ScraperManager.used_credits.used_credits.append(credit)
                    }
                }
            }
        }
    }
    
    private func parse_prices(json: Any) -> Void {
        //print(json)
        DispatchQueue.main.async {
            ScraperManager.prices.standard_prices.removeAll()
            ScraperManager.prices.monthlies_prices.removeAll()
            ScraperManager.prices.special_prices.removeAll()
            
            for price in json as! [Dictionary<String, AnyObject>] {                                           
                let credit_expiry = price["credit_expiry"] as? String ?? ""
                let start = credit_expiry.index(credit_expiry.startIndex, offsetBy: 2)
                let end = credit_expiry.index(credit_expiry.endIndex, offsetBy: -0)
                let range = start..<end
                let subStr = credit_expiry[range]
                
                let priceob = Price(id: price["id"] as? String ?? "",
                                    en: price["enabled"] as? String ?? "",
                                    mth: price["monthly"] as? String ?? "",
                                    ul: price["user_level"] as? String ?? "",
                                    nm: price["name"] as? String ?? "",
                                    p: price["price"] as? String ?? "",
                                    pbi: price["paypal_button_id"] as? String ?? "",
                                    pbc: price["paypal_button_code"] as? String ?? "",
                                    sd: price["start_date"] as? String ?? "",
                                    ed: price["end_date"] as? String ?? "",
                                    st: price["start_time"] as? String ?? "",
                                    et: price["end_time"] as? String ?? "",
                                    c: price["credits"] as? String ?? "",
                                    ce: String(subStr),
                                    pc: price["purchase_count"] as? String ?? "",
                                    ra: price["registered_after"] as? String ?? "",
                                    ctr: price["class_type_restriction"] as? String ?? "")
                    
                //print("added price")
                if(priceob.monthly == "1") {
                    ScraperManager.prices.monthlies_prices.append(priceob)
                    continue
                }
                
                if(priceob.class_type_restriction != "") {
                    ScraperManager.prices.special_prices.append(priceob)
                    continue
                }
                
                if(priceob.monthly == "0") {
                    ScraperManager.prices.standard_prices.append(priceob)
                    continue
                }
            }
        }
    }
    
    private func parse_bookings(json: Any) -> Void {
        //print(json)
        DispatchQueue.main.async {
            ScraperManager.bookings.bookings.removeAll()
            
            for booking in json as! [Dictionary<String, AnyObject>] {
                
                let bookingobj = Booking(id: booking["id"] as? String ?? "",
                                         class_id: booking["class_id"] as? String ?? "",
                                         date: booking["date"] as? String ?? "",
                                       start_time: booking["start_time"] as? String ?? "",
                                       end_time: booking["end_time"] as? String ?? "",
                                       class_name: booking["class_name"] as? String ?? "",
                                       instructor_name: booking["instructor_name"] as? String ?? "",
                                       murl: booking["murl"] as? String ?? "",
                                       doorArmedBeforeMins: booking["doorArmedBeforeMins"] as? String ?? "",
                                       doorDisarmedAfterMins: booking["doorDisarmedAfterMins"] as? String ?? "")
                ScraperManager.bookings.bookings.append(bookingobj)
                //print("added booking")
            }
        }
    }
    
    private func parse_classes(json: Any) -> Void {
        //print(json)
        DispatchQueue.main.async {
            ScraperManager.classes.classes.removeAll();
            ScraperManager.classes.sticky_classes.removeAll();
            
            for classjson in json as! [Dictionary<String, AnyObject>] {                                           
                let first_booking_title = classjson["first_booking_title"] as? String ?? ""
                let first_booking_message = classjson["first_booking_message"] as? String ?? ""
                let sticky = classjson["sticky"] as? String ?? ""
                
                let classob = Class(class_id: classjson["class_id"] as? String ?? "",
                                    week: classjson["week"] as? String ?? "",
                                    date: classjson["date"] as? String ?? "",
                                    start_time: classjson["start_time"] as? String ?? "",
                                    end_time: classjson["end_time"] as? String ?? "",
                                    name: classjson["name"] as? String ?? "",
                                    instructor: classjson["instructor"] as? String ?? "",
                                    class_instructor: classjson["class_instructor"] as? String ?? "",
                                    cancellation_warning: classjson["cancellation_warning"] as? Bool ?? false,
                                    book_button_action: classjson["book_button_action"] as? String ?? "",
                                    first_booking_frequency: classjson["first_booking_frequency"] as? String ?? "",
                                    first_booking_title: first_booking_title,
                                    first_booking_message: first_booking_message,
                                    free: classjson["free"] as? Bool ?? false,
                                    max_attendees: classjson["max_attendees"] as? String ?? "",
                                    class_quota: classjson["class_quota"] as? Int ?? 0,
                                    class_type: classjson["class_type"] as? String ?? "",
                                    description: classjson["description"] as? String ?? "",
                                    disabled: classjson["disabled"] as? Bool ?? false,
                                    button_text: classjson["button_text"] as? String ?? "",
                                    waitlist: classjson["waitlist"] as? String ?? "",
                                    token_restriction: classjson["token_restriction"] as? String ?? "",
                                    sticky: classjson["sticky"] as? String ?? "")
                
                if( sticky == "1" ) {
                    ScraperManager.classes.sticky_classes.append(classob)
                }
                else {
                    ScraperManager.classes.classes.append(classob)
                }
                //print("added class")
            }
        }
    }
    
    private func parse_logged_in(action: String, result: Any, error: Any) {
        print("login async: action : " + action)
        print("login async: result : " + String(result as! Bool))
        print("login async: error : " + (error as! String))
        
        let loggedin = result as? Bool ?? false
        ScraperManager.login_status = LoginStatus(a: action, r: result as! Bool, e: error as! String)
        let pl = Payload( "")
        
        DispatchQueue.main.async {
            if loggedin {
                self.notify(source: UpdateSource.scraper, requestview: RequestedView.navprofile, loginstate: ScraperManager.login_status!, payload: pl, error: ApiError("",""))
                self.fetch_all()
            }
            else {
                self.notify(source: UpdateSource.scraper, requestview: RequestedView.login, loginstate: ScraperManager.login_status!, payload: pl, error: ApiError("",""))
            }
        }
    }
        
    public func notify(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        DispatchQueue.main.async {
            for obj in ScraperManager.observers! {
                obj.update(source: source, requestview: requestview, loginstate: loginstate, payload: payload, error: error);
            }
        }
    }
    
    public func attach(obj: Observer) {
        ScraperManager.observers?.append(obj)
    }
    
    public func detach(obj: Observer) {
        return
    }
}


