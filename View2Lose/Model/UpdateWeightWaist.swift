//
//  UpdateWeightWaist.swift
//  View2Lose
//
//  Created by Jason on 30/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

struct UpdateWWRes: Codable {
    var ResponseMessage: String
    
    enum CodingKeys: String, CodingKey {
        case ResponseMessage = "ResponseMesssage"
    }
}
