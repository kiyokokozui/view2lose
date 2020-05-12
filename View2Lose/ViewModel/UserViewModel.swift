//
//  UserViewModel.swift
//  View2Lose
//
//  Created by Sagar on 17/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject, Identifiable {
    
    @Published var userObect: UserStore? {
        didSet {
            let encoder = JSONEncoder()
            if let encoder = try? encoder.encode(userObect) {
                let defaults = UserDefaults.standard
                defaults.set(encoder, forKey: "userObject")
                
            }
        }
    }
    
    init() {
        let defaults = UserDefaults.standard
        if let saveUser = defaults.object(forKey: "userObject") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(UserStore.self, from: saveUser) {
                self.userObect = loadedUser
                print("From Int \(self.userObect?.name)")
                
                return
            }
        }
    }
    
    func getFirstName(fullName: String) -> String {
        var components = fullName.components(separatedBy: " ")
        if components.count > 0 {
            return components.removeFirst()
        }
        return fullName
    }
}


