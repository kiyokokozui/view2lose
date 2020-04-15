//
//  SessionStore.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

class SessionStore: ObservableObject {
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "userLoggedIn") {
        didSet {
            UserDefaults.standard.set(self.isLoggedIn, forKey: "")
        }
    }
    var didChage = PassthroughSubject<SessionStore, Never>()
    @Published var session: UserStore? { didSet { self.didChage.send(self) }}
    
    func listen() {
        if isLoggedIn {
            //session = User(uid: "123123", email: "schhet07@gmail.com", firstName: "Sagar", lastName: "Chhetri")
            //session = UserDefaults.standard.object(forKey: "userSignedIn") as? UserStore
        }
    }
    
}

struct User {
    var uid: String
    var email: String?
    var firstName: String?
    var lastName: String?
    
    init(uid: String, email: String?, firstName: String?, lastName: String?) {
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
