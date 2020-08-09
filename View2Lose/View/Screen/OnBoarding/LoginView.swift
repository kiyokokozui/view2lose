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
import AuthenticationServices
import KeychainSwift

struct LoginView: View {
    @State var fbLogin = FBLoginProvider()
    @EnvironmentObject var user: SessionStore
    @EnvironmentObject var facebookManager: FacebookManager
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager
    
    @State private var signInWithappleDelegates : SignInWithAppleDelegates! = nil
    @Environment(\.window) var window: UIWindow?

    //Instagram
    @State var instagramApi = InstagramApi.shared
    @State var signedIn = false
    @State var presentAuth = false
    @State var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    @State var instagramUser: InstagramUser?
    //@EnvironmentObject var instagramManager: InstagramManager


    
    var body: some View {
        NavigationView {
        VStack {
            Image("Logo-and-tagline")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 260, height: 260)
                .padding(.top, 64)
            
            VStack {
                VStack {
                    Spacer()
                Text("Welcome!")
//                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    //.padding(.bottom, 15)
                    .modifier(CustomHeaderFontModifier(size: 40))
                    .foregroundColor(.white)

               

                }
                
                VStack (alignment: .center, spacing: 10) {
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
                            case .cameraOnboard:
                                FrontFacingCameraView()
                            case .cameraOnBoard2:
                                SideFacingCameraView()
                            
                            case .frontBodyMeasurement:
                                print("Authicated frontBodyMeasurement")
                            case .sideBodyMeasurement:
                                print("Authicated sideBodyMeasurement")

                            case .imagePreview:
                                print("Authicated ImagePreview")

                            case .postOnBoardLoading:
                                PostOnBoardingLoadingView()
                            case .cameratutorial:
                                CameraTutorialFirstView()
                                
                            case .updateMeasurement:
                                UpdateMeasurement()
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
                            .minimumScaleFactor(0.85)


                            
                        }
                    }).padding()
                        .padding(.horizontal, 20)
                        .background(Color(#colorLiteral(red: 0.2673539817, green: 0.4194847345, blue: 0.8548354506, alpha: 1)))
                        .cornerRadius(33)
                        .padding(.bottom, 10)
                    
                    
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
                                .minimumScaleFactor(0.85)


                        
                        }
                        
                        
                    })
                        .padding()
                        
                        .padding(.horizontal, 20)

                        
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9965491891, green: 0.8538320661, blue: 0.4573215246, alpha: 1)), Color(#colorLiteral(red: 0.980302155, green: 0.4927219152, blue: 0.1199619249, alpha: 1)),Color(#colorLiteral(red: 0.8401840925, green: 0.160092622, blue: 0.463200748, alpha: 1)),Color(#colorLiteral(red: 0.5886078477, green: 0.1843836606, blue: 0.7480129004, alpha: 1)),Color(#colorLiteral(red: 0.3114062548, green: 0.3560265303, blue: 0.8351828456, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(33)
                       .padding(.bottom, 10)
                        
                        .sheet(isPresented: self.$presentAuth , onDismiss: {
//                            ContentView(viewModel: UserViewModel())
                          //  self.facebookManager.isUserAuthenticated = .userOnBoard
                            print("Dismissed ")
                        }) {
                            WebView(presentAuth: self.$presentAuth, testUserData:     self.$testUserData, instagramApi: self.$instagramApi)


                    }

                    
                   SignInWithAppleButton().cornerRadius(33)

                                      //.padding(.horizontal, 30)
                                      .padding(.bottom, 15)
                    .frame(height: 74, alignment: .center)
                    .padding(.bottom, 50)
                    //.modifier(CustomBodyFontModifier(size: 21))

                    //.minimumScaleFactor(0.9)

                    .onTapGesture {
                        self.facebookManager.checkAppleUserAuth { (authState) in
                            switch authState {
                            case .undefined:
                                print("Auth State: .undefined")
                                self.showAppleLogin()

                              //self.performExistingAccountSetupFlows()
                            case .signedOut:
                                print("Auth State: .signedOut")

                            case .signedIn:
                                print("Auth State: .signedIn")

                            case .userOnBoard:
                                print("Auth State: .userOnBoard")
                                
                            case .cameraOnboard:
                                print("Auth State: .cameraOnboard")

                            case .cameraOnBoard2:
                                print("Auth State: .cameraOnBoard2")

                            case .frontBodyMeasurement:
                                print("Auth State: .frontBodyMeasurement")

                            case .sideBodyMeasurement:
                                print("Auth State: .sideBodyMeasurement")

                            case .imagePreview:
                                print("Auth State: .imagePreview")

                            case .postOnBoardLoading:
                                print("Auth State: .postLoading")

                            case .cameratutorial:
                                print("Auth State: .cameraTutorial")
                            case .updateMeasurement:
                                print("Auth State: .updateMeasurement")
                            }
                        }
                       }


                    

                }
                //.frame(maxWidth: 300)
               .padding(.bottom, 20)
                    .padding(.horizontal, 30)
               

                
            }
         

            }.background(Color("primary"))
            .edgesIgnoringSafeArea(.all)
            
        }
        .edgesIgnoringSafeArea(.all)
        
        
}
    
    private func showAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        performSign(using: [request])
    }
    
//    private func performExistingAccountSetupFlows () {
//        #if !targetEnvironment(simulator)
//        let request  = [
//            ASAuthorizationAppleIDProvider().createRequest(),
//            ASAuthorizationPasswordProvider().createRequest()
//        ]
//       // request.requestedScopes = [.fullName, .email]
//
//        performSign(using: request)
//        #endif
//    }
    
    private func performSign(using request: [ASAuthorizationRequest]) {
        signInWithappleDelegates = SignInWithAppleDelegates(window: window, onSignedIn: { (result) in
            switch result {
            case .success(let userId):
               
                self.signInToServer()
             //   UserDefaults.standard.set(userId, forKey: self.facebookManager.userIdentifierKey)
                //self.signInWithAppleManager.isUserAuthenticated = .signedIn
               
            case .failure(let err):
                //self.errDescription = err.localizedDescription
                print("Sign In with App Failure: \(err)")
            }
        })
        let controller = ASAuthorizationController(authorizationRequests: request)
        controller.delegate = signInWithappleDelegates
        controller.presentationContextProvider = signInWithappleDelegates
        controller.performRequests()
    }
    
    
    
    
    private func signInToServer() {
        
        let keychain = KeychainSwift()
             
               let emailFromApple = keychain.get("BBIEmailKey")
               let emailFromFacebook = keychain.get("emailFromApple")
            
        
        BBIModelEndpoint.sharedService.login(email: (emailFromApple ?? emailFromFacebook) ?? "defaultUserName") { result in
                           switch result {
                           case.success(let response):
                               print("Login success!!!!!!! \nUser ID:\(response.ResponseObject.UserId)\nUser Email:\(emailFromApple ?? emailFromFacebook)\n")
                               UserDefaults.standard.set(response.ResponseObject.UserId, forKey: "userId")
                               UserDefaults.standard.set((emailFromApple ?? emailFromFacebook), forKey: "userEmail")
                               UserDefaults.standard.set(response.ResponseObject.Height, forKey: "BBIHeightKey")

                               self.getImagesFromServer(email: (emailFromApple ?? emailFromFacebook) ?? "defaultUserName")
                              
//                               if self.gotImagesFromServer(email: emailFromApple){
//                                completion(true,true) //signed in with pics
//                               }else{
//                                completion(true,false)// signed in, but without pics
//                                self.facebookManager.isUserAuthenticated = .cameratutorial
//                               }
                               
                               
                                
                               completion(true,false)
                               break
                           
                           case .failure(let error):
                               print("Login failed =========", error)
                                self.facebookManager.isUserAuthenticated = .userOnBoard
                               break
                           }
                       }
    }
    
    func getImagesFromServer(userEmail: String!){
        BBIModelEndpoint.sharedService.getAllUserImages(email: userEmail) { result in
            
            switch result {
            case .success(let response):
             print("GET USER IMAGES RESPONSE ===== ", response)
             DispatchQueue.main.async {
                self.facebookManager.isUserAuthenticated = .signedIn
             }
            
             break
            case .failure(let error):
             print("GET USER IMAGES FAILED ====== ", error)
             DispatchQueue.main.async {
                 self.facebookManager.isUserAuthenticated = .userOnBoard
               // self.facebookManager.isUserAuthenticated = .cameratutorial
             }
            
             break
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


