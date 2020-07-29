//
//  SideViewController.swift
//  View2Lose
//
//  Created by Sagar on 18/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import KeychainSwift

protocol SideViewDelegate: class {
   // func newSideMeasurements(_ top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
    func sideNewMeasurement(_ top: CGPoint, left: CGPoint, bottom: CGPoint, right: CGPoint, approximation: CGFloat)
}

class SideViewController: UIViewController {
    
    // Used For Screen Pts To Picture Pts Translation
    var imageSize: CGSize = CGSize.zero
    var imageTopOffset: CGFloat = 0.0
    var cameraAspectRatio: CGFloat = 0.0
    var imageHeightRelativeToScreen: CGFloat = 0.0
    
    var totalInches: Int = 0
    var currentApproximation: CGFloat = 0.0
    var sideControlView: MainControlView = MainControlView(imageName: "com.smr.side.png")
    let screenSize = UIScreen.main.bounds
    var sideDelegate: SideViewDelegate!
    var globalValues = KeychainSwift()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //currentMeasurments = Measurements()
        
        sideControlView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sideControlView)
        
        sideControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sideControlView.topAnchor.constraint(equalTo: view.topAnchor,constant: 40).isActive = true
        sideControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Used For Screen Pts To Picture Pts Translation
        imageSize = self.sideControlView.imageView!.image?.size ?? CGSize.zero
              cameraAspectRatio = CGFloat(4.0/3.0)
              
              // Used For Screen Pts To Picture Pts Translation
              imageHeightRelativeToScreen = screenSize.width * cameraAspectRatio
              imageTopOffset = ((self.sideControlView.imageView?.bounds.height)! - imageHeightRelativeToScreen) / 2.0
               
               sideControlView.heightAnchor.constraint(equalToConstant: imageHeightRelativeToScreen).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         let filename = getDocumentsDirectory().appendingPathComponent("com.smr.side.png")
         if let image = UIImage(contentsOfFile: filename) {
           //  frontControlView = MainControlView(imageName: )
             self.sideControlView.imageView!.image = image
         }
         
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Used For Screen Pts To Picture Pts Translation
               imageHeightRelativeToScreen = screenSize.width * cameraAspectRatio
        imageTopOffset = (self.sideControlView.imageView!.bounds.height - imageHeightRelativeToScreen) / 2.0
               
               // Update & Calculate Size
               self.sideControlView.updateMeasurements()
               //calculateSize()
    }
     
     // MARK: Get Documents Directory
        
        func getDocumentsDirectory() -> NSString {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            return documentsDirectory as NSString
        }
        
    
//    func newMeasurements(_ top: CGFloat, leftX: CGFloat, leftY: CGFloat, bottom: CGFloat, rightX: CGFloat, rightY: CGFloat) {
//      //  labelXConstant.constant = round(leftX) + 30.0
//             //  labelYConstant.constant = screenSize.height - 64.0 - round(leftY) + 20.0 // 64.0 Offset From Nav Bar
//
//               currentMeasurments!.sideSet = true
//               currentMeasurments!.sideTop = top
//               currentMeasurments!.sideLeft = leftX
//               currentMeasurments!.sideBottom = bottom
//               currentMeasurments!.sideRight = rightX
//               calculateSize()
//
//        // Convert Pts To Picture Pts
//
//
//
//    }
    
    
     // MARK: Calculate Size
     
//     func calculateSize() {
//        if !currentMeasurments.frontSet || !currentMeasurments.sideSet || totalInches == 0  {
//            return
//        }
//
//        // Get Actual Height In Pixels
//        let frontHeightPixels = currentMeasurments.frontBottom - currentMeasurments.frontTop
//        let sideHeightPixels = currentMeasurments.sideBottom - currentMeasurments.sideTop
//
//        // Calculate The Pixels Per Inch For Front & Back
//        // These Might Be Different As The Height Might Be Different In Each Picture
//        // We Will Use This To Calculate How To Scale The Side Picture To Match The Front
//        let frontPixelsPerInch = frontHeightPixels / CGFloat(totalInches)
//        let sidePixelsPerInch = sideHeightPixels / CGFloat(totalInches)
//
//        // Get Major Radius In Inches (Front Pic) & Minor Radius In Inches (Side Pic)
//        let major_rad = ((abs(currentMeasurments.frontLeftX - currentMeasurments.frontRightX)) / frontPixelsPerInch)
//        let minor_rad = ((abs(currentMeasurments.sideLeft - currentMeasurments.sideRight)) / sidePixelsPerInch)
//
//        // Approximation Formula
//        let a_minus_b_squared = (major_rad - minor_rad) * (major_rad - minor_rad)
//        let a_plus_b_squared = (major_rad + minor_rad) * (major_rad + minor_rad)
//        let h = a_minus_b_squared / a_plus_b_squared
//
//        let pi_times_a_plus_b = .pi * (major_rad + minor_rad)
//        let main_math = (1.0 + ((3.0 * h) / (10.0 + sqrt(4.0 - (3.0 * h)))))
//        currentApproximation = (pi_times_a_plus_b * main_math) / 2.0
//
//       // let approx_inch = String(Int(currentApproximation))
//      //  let approx_fraction = getDisplayFraction(currentApproximation)
//
//
//        let convertPtLeft = self.convertPointToPicturePt(CGPoint(x: currentMeasurments.frontLeftX, y: currentMeasurments.frontLeftY), imageView: self.sideControlView.imageView!)
//        let convertPtRight = self.convertPointToPicturePt(CGPoint(x: currentMeasurments.frontRightX, y: currentMeasurments.frontRightY), imageView: self.sideControlView.imageView!)
//           let convertPtTop = self.convertPointToPicturePt(CGPoint(x: 0.0, y: currentMeasurments.frontTop) , imageView: self.sideControlView.imageView!)
//        let convertPtBottom = self.convertPointToPicturePt(CGPoint(x: 0.0, y: currentMeasurments.frontBottom) , imageView: self.sideControlView.imageView!)
//
//
//
//        let leftNavalDic = [ "X" : Int(convertPtLeft.x), "Y" : Int(convertPtLeft.y) ]
//
//        let rightNavalDic = [ "X" : Int(convertPtRight.x), "Y" : Int(convertPtRight.y) ]
//        let encoder = JSONEncoder()
//
//        if let leftNavalDicData = try? encoder.encode(leftNavalDic) {
//            globalValues.set(leftNavalDicData, forKey: "LeftNavalPointDictKey")
//        }
//
//        if let rightNavalDicData = try? encoder.encode(rightNavalDic) {
//            globalValues.set(rightNavalDicData, forKey: "RightNavalPointDictKey")
//        }
//
//
//        if let convertPtTopData = try? encoder.encode(convertPtTop.y) {
//            globalValues.set(convertPtTopData, forKey: "TopOfHeadKey")
//        }
//
//        if let convertPtBottomData = try? encoder.encode(convertPtBottom.y) {
//            globalValues.set(convertPtBottomData, forKey: "BottomOfFeetKey")
//        }
//
//        if let currentApproximationData = try? encoder.encode(currentApproximation) {
//            globalValues.set(currentApproximationData, forKey: "currentApproximationKey")
//        }
//
//
//
//
//
////        globalValues.set(rightNavalDic, forKey: "RightNavalPointDictKey")
////        globalValues.set(convertPtTop.y, forKey: "TopOfHeadKey")
////        globalValues.set(convertPtBottom.y, forKey: "BottomOfFeetKey")
//
//
//
//
//
//       // setSizeApproximation(approx_inch + " " + approx_fraction)
//        self.sideDelegate.sideNewMeasurement(convertPtTop, left: convertPtLeft, bottom: convertPtBottom, right: convertPtRight, approximation: currentApproximation)
//        print("CurrentApprox: \(convertPtTop)")
//    }
    
    // Turn Fraction Into Display Value
    
    func getDisplayFraction(_ value: CGFloat) -> String {
        let part = value.truncatingRemainder(dividingBy: 1)
        var returnValueString = ""
        if part >= 0.125 && part <= 0.25 {
            returnValueString = "1/8"
        } else if part > 0.25 && part <= 0.375 {
            returnValueString = "1/4"
        } else if part > 0.375 && part <= 0.5 {
            returnValueString = "1/2"
        } else if part > 0.5 && part <= 0.625 {
            returnValueString = "5/8"
        } else if part > 0.625 && part <= 0.75 {
            returnValueString = "3/4"
        } else if part > 0.75 {
            returnValueString = "7/8"
        }
        return returnValueString
    }
    
    func convertPointToPicturePt(_ pt: CGPoint, imageView: UIImageView) -> CGPoint {
        let translatedImagePtX = (pt.x / imageView.bounds.size.width) * imageSize.width
        
        // Need To Account For Top And Bottom Padding In ImageView When Taking Pt Percentages For Y
        let adjustedYForTopOffset = pt.y - imageTopOffset
        let translatedImagePtY = (adjustedYForTopOffset / (imageView.bounds.size.height - (imageTopOffset * 2))) * imageSize.height
        
        return CGPoint(x: translatedImagePtX, y: translatedImagePtY)
    }
    
    static func onTapCreate() {
        
    }
    
    
}
