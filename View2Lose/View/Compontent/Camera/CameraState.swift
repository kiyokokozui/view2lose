//
//  CameraState.swift
//  View2Lose
//
//  Created by Sagar on 3/5/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import UIKit

public class CameraState : NSObject, ObservableObject {
    @Published public var capturedImage : UIImage?
    @Published public var capturedImageError : Error?
}
