//
//  ContentView.swift
//  Ashtanga Yoga Cork
//
//  Created by Dave on 03/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import SwiftUI
import Combine


struct LoginView: View, Observer {
    @State private var alertmsg: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginButtonText: String = "LOGIN"
    @State public var loginFailed: Bool = false
    @State public var loginFailedMessage: String = "test"
    
    var body: some View {
            VStack {
                VStack(alignment: .center, spacing: 15){
                    Image("login_logo").resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200.0, height: 200.0, alignment: .center)
                        .padding(.bottom, 20.0)
                    HStack {
                      TextField("Enter username", text: $username)
                        .multilineTextAlignment(.center)
                        .font(.system(size:18, weight: .bold)
                      )
                        .padding()
                        .background(Color(hex: 0xE8F0FE))
                        .frame(width: 250, height: nil, alignment: .center)
                        .border(Color(hex: 0x7e8993), width: 2)
                        .padding(8.0)
                    }

                    HStack {
                      SecureField("Enter password", text: $password)
                      .multilineTextAlignment(.center)
                      .font(.system(size:18, weight: .bold))
                        .padding()
                        .background(Color(hex: 0xE8F0FE))
                        .frame(width: 250, height: nil, alignment: .center)
                        .border(Color(hex: 0x7e8993), width: 2)
                        .padding(8.0)
                    }
                    Button(action: {
                        self.loginFailed = false
                        let u_len = self.username.count
                        let p_len = self.password.count
                        
                        if u_len > 3 && p_len > 3 {
                            var postfields: String = "log=" + self.username;
                            postfields = postfields + "&pwd=" + self.password;
                            postfields = postfields + "&wp-submit=Log+In&redirect_to=https%3A%2F%2Fashtangayoga.ie%2Fprofile%2F&testcookie=1";
                            let sm = ScraperManager.getInstance()
                            sm.login(postfields: postfields)
                            self.loginButtonText = "Standby.."
                            _ = self.disabled(true)
                        }
                        else {
                            print("too short")
                            self.alertmsg = u_len < 4 ? "Username is too short" : ""
                            self.alertmsg = p_len < 4 ? "Password is too short" : self.alertmsg
                            
                            ScraperManager.getInstance().notify(
                                source: UpdateSource.scraper,
                                requestview: RequestedView.login,
                                loginstate: ScraperManager.login_status!,
                                payload: Payload(""),
                                error: ApiError("Invalid credentails", self.alertmsg))
                        }
                    }) {
                        Text(self.loginButtonText).font(Common.Ufont14Bold)
                    }
                    .buttonStyle(ImageButton())
                    .frame(width: 100, height: 40, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .border(Color.black, width: 2)
                    if self.loginFailed {
                        Text(self.loginFailedMessage).foregroundColor(Color.red).bold()
                    }
                    /*
                    HStack(spacing: 0) {
                        Button(action: {
                            SLView.viewModel.facebook = true
                            let sm = ScraperManager.getInstance();
                            ScraperManager.getInstance().clear_cookies();
                            sm.notify(source: UpdateSource.login,
                                      requestview: RequestedView.social,
                                      loginstate: ScraperManager.login_status!,
                                      payload: Payload(""),
                                      error: ApiError("",""))
                        }) {
                            Image("fb")
                        }
                        .buttonStyle(ImageButton())
                        .frame(width: 48, height: 48, alignment: .center)
                        Button(action: {
                            SLView.viewModel.facebook = false
                            let sm = ScraperManager.getInstance();
                            ScraperManager.getInstance().clear_cookies();
                            sm.notify(source: UpdateSource.login,
                                      requestview: RequestedView.social,
                                      loginstate: ScraperManager.login_status!,
                                      payload: Payload(""),
                                      error: ApiError("",""))
                        }) {
                            Image("goog")
                        }
                        .buttonStyle(ImageButton())
                        .frame(width: 48, height: 48, alignment: .center)
                    }
                    */ 
                    Divider().hidden()
                    HStack{
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://ashtangayoga.ie/wp-login.php?action=register")!)
                        }) {
                            Text("Register")
                        }
                        Text(" | ")
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://ashtangayoga.ie/wp-login.php?action=lostpassword")!)
                        }) {
                            Text("Lost password?")
                        }
                    }
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://ashtangayoga.ie/privacy-policy")!)
                    }) {
                        Text("Privacy policy")
                    }
                }
                .background(Image("background").resizable(resizingMode: .tile))
                .padding(.all, 60.0)
                .frame(width: 250.0, height: 600.0)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(hex: 0xFFFFFF))
    }
    
    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        print("Received login state: " + String(loginstate.result))
        if source == UpdateSource.social {
            DispatchQueue.main.async {
                ScraperManager.getInstance().fetch_async(action: "check_logged_in", postfields: "")
            }
            return;
        }
        DispatchQueue.main.async {
            self.loginButtonText = "LOGIN"
            _ = self.disabled(false)
        }
        if loginstate.result == false {
            self.loginFailed = true
            self.loginFailedMessage = loginstate.error
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
