//
//  UserStore.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine
import AuthenticationServices

class UserStore : Codable  {

    let id = UUID()
    let email: String
    let name: String
    
    
    init(email: String, name: String) {
        self.email = email
        self.name = name
    }
    
    init(appleCredentials: ASAuthorizationAppleIDCredential) {
        //self.id = appleCredentials.user
        self.email = appleCredentials.email ?? ""
        self.name = appleCredentials.fullName?.givenName ?? ""
        
    }
}
