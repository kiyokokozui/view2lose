//
//  CameraViewDelegate.swift
//  View2Lose
//
//  Created by Sagar on 3/5/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation

public protocol CameraViewDelegate {
    func cameraAccessGranted()
    func cameraAccessDenied()
    func noCameraDetected()
    func cameraSessionStarted()
}
