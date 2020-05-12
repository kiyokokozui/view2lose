//
//  FBLogin.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import FacebookLogin
import Combine

class FacebookLoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

struct FBLoginProvider: UIViewControllerRepresentable {
    let loginController = FacebookLoginViewController()
    @EnvironmentObject var user: SessionStore
    
    

    func makeUIViewController(context: Context) -> UIViewController {
        
        return loginController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func loginWithReadPermission(completion: @escaping (LoginResult) -> ()) {
        
        let loginManger = LoginManager()
        loginManger.logIn(permissions: [.email, .publicProfile], viewController: loginController) { (result) in
            completion(result)
        }
    }
        
    func getFBUserData(completion: @escaping (UserStore) -> ()) {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, gender"]).start { (connection, result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                let dict = result as! [String: AnyObject]
                

                let nameOfUser = dict["name"] as! String
                let email = dict["email"] as! String
                let user = UserStore(email: email, name: nameOfUser)
                completion(user)

            }
        }
    }
}
