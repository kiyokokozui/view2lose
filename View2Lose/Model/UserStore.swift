//
//  UserStore.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

class UserStore  {

    let email: String
    let name: String
    
    init(email: String, name: String) {
        self.email = email
        self.name = name
    }
}
