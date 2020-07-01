//
//  MeasurementViewModel.swift
//  View2Lose
//
//  Created by Sagar on 16/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import Combine


class MeasurementViewModel: ObservableObject, Identifiable, ControlViewDelegate {
    
    let WillChange = PassthroughSubject<Measurements, Never>()

    var currentMeasurments = Measurements()
    var totalInches: Int = 0
    var currentApproximation: CGFloat = 0.0
    var imageSize: CGSize = CGSize.zero
    var imageTopOffset: CGFloat = 0.0

    
    init() {
        
    }


    func newMeasurements(_ top: CGFloat, leftX: CGFloat, leftY: CGFloat, bottom: CGFloat, rightX: CGFloat, rightY: CGFloat) {
        currentMeasurments.frontSet = true
        currentMeasurments.frontTop = top
        currentMeasurments.frontLeftX = leftX
        currentMeasurments.frontLeftY = leftY
        currentMeasurments.frontBottom = bottom
        currentMeasurments.frontRightX = rightX
        currentMeasurments.frontRightY = rightY
        self.WillChange.send(currentMeasurments)
    }
    
    // MARK: Calculate Size
    
    func calculateSize() {
        if !currentMeasurments.frontSet || !currentMeasurments.sideSet || totalInches == 0  {
            return
        }
        
        // Get Actual Height In Pixels
        let frontHeightPixels = currentMeasurments.frontBottom - currentMeasurments.frontTop
        let sideHeightPixels = currentMeasurments.sideBottom - currentMeasurments.sideTop
        
        // Calculate The Pixels Per Inch For Front & Back
        // These Might Be Different As The Height Might Be Different In Each Picture
        // We Will Use This To Calculate How To Scale The Side Picture To Match The Front
        let frontPixelsPerInch = frontHeightPixels / CGFloat(totalInches)
        let sidePixelsPerInch = sideHeightPixels / CGFloat(totalInches)
        
        // Get Major Radius In Inches (Front Pic) & Minor Radius In Inches (Side Pic)
        let major_rad = ((fabs(currentMeasurments.frontLeftX - currentMeasurments.frontRightX)) / frontPixelsPerInch)
        let minor_rad = ((fabs(currentMeasurments.sideLeft - currentMeasurments.sideRight)) / sidePixelsPerInch)
        
        // Approximation Formula
        let a_minus_b_squared = (major_rad - minor_rad) * (major_rad - minor_rad)
        let a_plus_b_squared = (major_rad + minor_rad) * (major_rad + minor_rad)
        let h = a_minus_b_squared / a_plus_b_squared
        
        let pi_times_a_plus_b = .pi * (major_rad + minor_rad)
        let main_math = (1.0 + ((3.0 * h) / (10.0 + sqrt(4.0 - (3.0 * h)))))
        currentApproximation = (pi_times_a_plus_b * main_math) / 2.0
        
        let approx_inch = String(Int(currentApproximation))
        let approx_fraction = getDisplayFraction(currentApproximation)
        
        
      //  setSizeApproximation(approx_inch + " " + approx_fraction)
    }
    
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
    
    // Set & Show Approximation
    
//    func setSizeApproximation(_ sizeString: String) {
//        if sideSizeLabel.isHidden {
//            sideSizeLabel.isHidden = false
//        }
//        sideSizeLabel.text = sizeString
//    }
    
    func convertPointToPicturePt(_ pt: CGPoint, imageView: UIImageView) -> CGPoint {
        let translatedImagePtX = (pt.x / imageView.bounds.size.width) * imageSize.width
        
        // Need To Account For Top And Bottom Padding In ImageView When Taking Pt Percentages For Y
        let adjustedYForTopOffset = pt.y - imageTopOffset
        let translatedImagePtY = (adjustedYForTopOffset / (imageView.bounds.size.height - (imageTopOffset * 2))) * imageSize.height
        
        return CGPoint(x: translatedImagePtX, y: translatedImagePtY)
    }
    
    func createWrapImages() {
        
        /*
        let stringApprox = NSString(format: "%.1f", currentApproximation)
        globalValues.setObject(stringApprox, forKey:BBIGlobalValuesKeychainWaistInchesKey as NSCopying)
        
        // Convert Pts To Picture Pts
        let convertPtLeft = self.convertPointToPicturePt(CGPoint(x: currentMeasurments!.frontLeftX, y: currentMeasurments!.frontLeftY), imageView: self.sideControlView.imageView)
        let convertPtRight = self.convertPointToPicturePt(CGPoint(x: currentMeasurments!.frontRightX, y: currentMeasurments!.frontRightY), imageView: self.sideControlView.imageView)
        let convertPtTop = self.convertPointToPicturePt(CGPoint(x: 0.0, y: currentMeasurments!.frontTop) , imageView: self.sideControlView.imageView)
        let convertPtBottom = self.convertPointToPicturePt(CGPoint(x: 0.0, y: currentMeasurments!.frontBottom) , imageView: self.sideControlView.imageView)
        
        let leftNavalDic = [ "X" : Int(convertPtLeft.x), "Y" : Int(convertPtLeft.y) ]
        let rightNavalDic = [ "X" : Int(convertPtRight.x), "Y" : Int(convertPtRight.y) ]
 */
    }
 
 
    
    
}
