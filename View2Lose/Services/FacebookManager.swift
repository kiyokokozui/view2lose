//
//  FacebookManager.swift
//  View2Lose
//
//  Created by Sagar on 13/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import FacebookLogin
import AuthenticationServices



class FacebookManager: ObservableObject {
    @Published var isUserAuthenticated: AuthState = .undefined
    
    let userIdentifierKey = "userIdentifierKey"
    
    func checkUserAuth(completion: @escaping (AuthState) -> ()) {
//        guard let userIdentifier = UserDefaults.standard.string(forKey: userIdentifierKey) else {
//            print("User identifier does not exist")
//            self.isUserAuthenticated = .undefined
//            completion(.undefined)
//            return
//        }
//        if userIdentifier == "" {
//            print("User identifier is empty string")
//            self.isUserAuthenticated = .undefined
//            completion(.undefined)
//            return
//        }
        
        let fbLoginProvider = FBLoginProvider()
        fbLoginProvider.loginWithReadPermission { (result) in
            switch result {
                
            case .success(granted: let granted, declined: let declined, token: let token):
                print("Credential state: .authorized")
                fbLoginProvider.getFBUserData { user in
                   // UserDefaults.standard.set(true, forKey: "userLoggedIn")
                   //UserDefaults.standard.set(user, forKey: "userSignedIn")
                    let userViewModel = UserViewModel()
                    userViewModel.userObect = user
                    print(userViewModel.userObect?.name)
                    self.isUserAuthenticated = .userOnBoard
                    completion(.userOnBoard)
                }
                break
            case .cancelled:
                print("Credential state: .cancelled")
                self.isUserAuthenticated = .undefined
                completion(.undefined)
                break
            case .failed(_):
                print("Credential state: .failed")
                self.isUserAuthenticated = .undefined
                completion(.undefined)
                break
            default:
                break
            }
        }
        
        
    }
    
    func checkAppleUserAuth(completion: @escaping (AuthState) -> ()) {
        guard let userIdentifier = UserDefaults.standard.string(forKey: userIdentifierKey) else {
            print("User identifier does not exist")
            self.isUserAuthenticated = .undefined
            completion(.undefined)
            return
        }
        if userIdentifier == "" {
            print("User identifier is empty string")
            self.isUserAuthenticated = .undefined
            completion(.undefined)
            return
        }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid. Show Home UI Here
                    print("Credential state: .authorized")
                    self.isUserAuthenticated = .userOnBoard
                    
                    let userViewModel = UserViewModel()
                    completion(.signedIn)
                    break
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    print("Credential state: .revoked")
                    self.isUserAuthenticated = .undefined
                    completion(.undefined)
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
                    print("Credential state: .notFound")
                    self.isUserAuthenticated = .signedOut
                    completion(.signedOut)
                    break
                default:
                    break
                }
            }
        }
    }
}
