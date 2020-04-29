//
//  LoginView.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import FBSDKLoginKit
import SafariServices


struct LoginView: View {
    @State var fbLogin = FBLoginProvider()
    @EnvironmentObject var user: SessionStore
    @EnvironmentObject var facebookManager: FacebookManager

    //Instagram
    @State var instagramApi = InstagramApi.shared
    @State var signedIn = false
    @State var presentAuth = false
    @State var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    @State var instagramUser: InstagramUser? = nil
    //@EnvironmentObject var instagramManager: InstagramManager


    
    var body: some View {
        NavigationView {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding(.top, 50)
            
            VStack {
                Spacer()
                VStack {
                Text("Welcome!")
//                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.bottom, 15)
                    .modifier(CustomHeaderFontModifier(size: 40))

                Text("Please login or signup to continue using the app.")
//                    .font(.system(size: 16))
                    .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .modifier(CustomBodyFontModifier(size: 16))

                }.padding(.bottom, 100)
                
                VStack (alignment: .trailing, spacing: 10) {
                    Button(action: {
                        self.facebookManager.checkUserAuth { (auth) in
                            switch(auth) {
                                
                            case .undefined:
                                print("Authentication Undefined")
                            case .signedOut:
                                print("Authentication SignOut")
                            case .signedIn:
                                print("Authentication SignedIn")
                                DashboardView()
                            case .userOnBoard:
                                print("Authentication UserOnBoard")

                                let viewModel = UserViewModel()
                                ContentView(viewModel: viewModel)
                            }
                        }
                    }, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image("facebook").resizable()
                                .renderingMode(.template)
                                .accentColor(Color(.white))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 8)
                            
                            Text("Continue with Facebook")
                                .foregroundColor(.white)
//                                .font(.system(size: 21))
                            .modifier(CustomBodyFontModifier(size: 21))

                            
                        }
                    }).padding()
                        .padding(.horizontal, 20)
                        .background(Color(#colorLiteral(red: 0.2673539817, green: 0.4194847345, blue: 0.8548354506, alpha: 1)))
                        .cornerRadius(33)
                        .padding(.bottom, 15)
                    

                    
                    Button(action: {
//                        if (self.testUserData.user_id == 0) {
//                            self.presentAuth.toggle()
//                        }
//                        else {
//
//                            self.instagramApi.getInstagramUser(testUserData: self.testUserData) { (user) in
//                                self.instagramUser = user
//                                self.signedIn.toggle()
//                            }
//                        }
                        self.presentAuth.toggle()
                        //WebView(presentAuth: self.$presentAuth, testUserData:     self.$testUserData, instagramApi: self.$instagramApi)
                        
                    }, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image("instagram").resizable()
                            .renderingMode(.template)
                            .accentColor(Color(.white))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .padding(.trailing, 8)
                            Text("Continue with Instagram")
                                .foregroundColor(.white)
//                                .font(.system(size: 21))
                            .modifier(CustomBodyFontModifier(size: 21))

                        
                        }
                        
                        
                    }).padding()
                        .padding(.horizontal, 20)
                        
                        
                        
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9965491891, green: 0.8538320661, blue: 0.4573215246, alpha: 1)), Color(#colorLiteral(red: 0.980302155, green: 0.4927219152, blue: 0.1199619249, alpha: 1)),Color(#colorLiteral(red: 0.8401840925, green: 0.160092622, blue: 0.463200748, alpha: 1)),Color(#colorLiteral(red: 0.5886078477, green: 0.1843836606, blue: 0.7480129004, alpha: 1)),Color(#colorLiteral(red: 0.3114062548, green: 0.3560265303, blue: 0.8351828456, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(33)
                        .padding(.bottom, 15)
                        
                        .sheet(isPresented: self.$presentAuth , onDismiss: {
//                            ContentView(viewModel: UserViewModel())
                            TestView()
                            print("Dismissed ")
                        }) {
                            WebView(presentAuth: self.$presentAuth, testUserData:     self.$testUserData, instagramApi: self.$instagramApi)


                    }
                    

                }
                .padding(.bottom, 20)

                
                
            }
            .padding(.bottom, 20)

        }
    }
}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


