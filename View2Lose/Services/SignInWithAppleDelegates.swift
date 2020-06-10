//
//  SignInWithAppleDelegates.swift
//  SwiftUISignInWithApple
//
//  Created by Alex Nagy on 03/11/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit
import AuthenticationServices

class SignInWithAppleDelegates: NSObject {
    private let signInSucceeded: (Result<UserStore?, Error>) -> ()
    private weak var window: UIWindow!
    
    init(window: UIWindow?, onSignedIn: @escaping (Result<UserStore?, Error>) -> ()) {
        self.window = window
        self.signInSucceeded = onSignedIn
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
    public func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Registering new account with user: \(credential.fullName?.givenName)")
        let appleUserObject = UserStore(appleCredentials: credential)
        UserDefaults.standard.set(credential.fullName?.givenName, forKey: "nameFromApple")

        self.signInSucceeded(.success(appleUserObject))
    }
    
    public func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Signing in with existing account with user: \(credential.fullName)")
        let appleUserObject = UserStore(appleCredentials: credential)
        //UserDefaults.standard.set(credential.fullName?.givenName, forKey: "nameFromApple")
       // print("new account with user: \(UserDefaults.standard.data(forKey: "nameFromApple"))")
        

        self.signInSucceeded(.success(appleUserObject))
    }
    //    private func signInWithUserAndPassword(credential: ASPasswordCredential) {

    public func signInWithUserAndPassword(credential: ASPasswordCredential) {
        print("Signing in using an existing iCloud Keychain credential with user: \(credential.user)")
        
        //UserDefaults.standard.set(credential.fullName?.givenName, forKey: "nameFromApple")

        self.signInSucceeded(.success(nil))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                registerNewAccount(credential: appleIdCredential)
            } else {
                signInWithExistingAccount(credential: appleIdCredential)
            }
            
            break
            
        case let passwordCredential as ASPasswordCredential:
            signInWithUserAndPassword(credential: passwordCredential)
            
            break
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.signInSucceeded(.failure(error))
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
}
