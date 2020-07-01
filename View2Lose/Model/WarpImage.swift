//
//  WarpImage.swift
//  View2Lose
//
//  Created by Sagar on 19/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

struct WarpImageResponse: Decodable {
    let ResponseObject: WarpImage
}

struct WarpImage: Decodable {
    let ProcessedImages: [Data]
}
