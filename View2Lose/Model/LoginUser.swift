//
//  LoginUser.swift
//  View2Lose
//
//  Created by Jason on 30/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

struct LoginUserResponse: Codable {
    var ResponseMessage: String
    var ResponseObject: ResLoginObj
    var ResponseState: Int
    
    enum CodingKeys: String, CodingKey {
        case ResponseMessage = "ResponseMesssage"
        case ResponseObject = "ResponseObject"
        case ResponseState = "ResponseState"
    }
}

struct ResLoginObj: Codable {
    var UserId: Int
}
