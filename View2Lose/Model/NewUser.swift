//
//  NewUser.swift
//  View2Lose
//
//  Created by Jason on 30/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

struct NewUserResponse: Codable {
    var ResponseCode: String
    var ResponseMessage: String
    var ResponseObject: ResObject
    var ResponseState: Int
    
    enum CodingKeys: String, CodingKey {
        case ResponseCode = "ResponseCode"
        case ResponseMessage = "ResponseMesssage"
        case ResponseObject = "ResponseObject"
        case ResponseState = "ResponseState"
    }
}

struct ResObject: Codable {
    var UserId: Int
}
