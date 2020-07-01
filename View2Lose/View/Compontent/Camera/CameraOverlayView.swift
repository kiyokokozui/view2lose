//
//  CameraOverlayView.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/3/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

class CameraOverlayView: UIView {
    let squareLayer = CAShapeLayer()
    var podInstructions: UILabel?
    var podImageview: UIImageView?
    var frontImage: UIImageView?
    //var verticalLevel: LevelControlView?
   //var horizontalLevel: LevelControlView?
    var isVerticallyLevel = false
    var isHorizontallyLevel = false
    
    convenience init() {
        let screenSize = UIScreen.main.bounds.size
        let cameraAspectRatio = CGFloat(4.0/3.0)
        let imageHeight = screenSize.width * cameraAspectRatio

        self.init(frame: CGRect(x: 0.0,
                                y: 44.0,
                                width: screenSize.width,
                                height: imageHeight))

        
        // Add Level Indicators
//        horizontalLevel = LevelControlView(levelType: .horizontalLevel, parentFrame: self.frame)
//        verticalLevel = LevelControlView(levelType: .verticalLevel, parentFrame: self.frame)
//        addSubview(self.horizontalLevel!)
//        addSubview(self.verticalLevel!)
        
        // Add Pod Instructions Label
        podInstructions = UILabel(frame: CGRect.zero)
        podInstructions?.backgroundColor = UIColor.clear
        podInstructions?.textColor = UIColor.white
        podInstructions?.textAlignment = .center
        podInstructions?.numberOfLines = 0
        podInstructions?.text = "Fit whole body in outline\n (head to toe)"
        
        self.addSquareBox()
    }
    
    // MARK: Show Side Pod
    
    @objc func showSidePod() {
        frontImage?.image = UIImage(named: "side_outline")
        frontImage?.layer.opacity = 1.0
        //fadeOutOutlineImage()
    }
    
    // MARK: Adjust Vertical Level
    
    func adjustVerticalLevel(value: Float) {
        let updatedVerticalValue = max(1.0, min((80.0 * value) + 40.0, 79.0))
        isVerticallyLevel = updatedVerticalValue >= 30.0 && updatedVerticalValue <= 50.0
        updateBoxColor()
        
        //self.verticalLevel?.adjustIndicator(CGFloat(value))
    }
    
    // MARK: Adjust Horizontal Level
    
    func adjustHorizontalLevel(value: Float) {
        let updatedHorizontalValue = max(1.0, min((80.0 * value) + 40.0, 79.0))
        isHorizontallyLevel = updatedHorizontalValue >= 36.0 && updatedHorizontalValue <= 42.0
        updateBoxColor()
        
        //self.horizontalLevel?.adjustIndicator(CGFloat(value))
    }
    
    // MARK: Update Box Color
    
    func updateBoxColor() {
        if isCameraLevel() {
            squareLayer.strokeColor = UIColor.green.cgColor
        } else {
            squareLayer.strokeColor = UIColor.red.cgColor
        }
    }
    
    // MARK: Is The Camera Level
    
    func isCameraLevel() -> Bool {
//        guard self.horizontalLevel != nil && self.verticalLevel != nil else {
//            return false
//        }
//        return self.horizontalLevel!.isLeveled && self.verticalLevel!.isLeveled
        return isHorizontallyLevel && isVerticallyLevel
    }
    
    // MARK: Get Body Image
    
    func getBodyTypeImageWithGenderString(_ gender: String, bodyType: Int) -> UIImage? {
        var bodyTypeString = "banana"
        switch (bodyType) {
        case 2:
            bodyTypeString = "apple"
            break
        case 3:
            bodyTypeString = "pear"
            break
        case 4:
            bodyTypeString = "potato"
            break
        default: ()
        }
        return UIImage(named: "\((gender == "Male") ? "man" : "woman")_\(bodyTypeString)")
    }
    
    // MARK: Add Square Box To View
    
    func addSquareBox() {
        squareLayer.path = UIBezierPath(roundedRect: CGRect(x: 10.0, y: 10.0, width: self.bounds.width - 20.0, height: self.bounds.height - 20.0), cornerRadius: 4.0).cgPath
        squareLayer.strokeColor = UIColor.red.cgColor
        squareLayer.fillColor = UIColor.clear.cgColor
        squareLayer.lineWidth = 2
        self.layer.addSublayer(squareLayer)
        
        frontImage = UIImageView(image: UIImage(named: "Front-silhouette"))
        
        let height = self.bounds.height*4/5
        let width = self.bounds.width*4/5
        frontImage!.frame = CGRect(x: self.bounds.width/2 - width/2, y: self.bounds.height/2 - height/2, width: width, height: height)
        frontImage!.contentMode = .scaleAspectFit
        self.addSubview(frontImage!)
    }
    
    func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return (NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)! as String).trimmingCharacters(in: CharacterSet.controlCharacters)
    }
    
    // MARK: Use This To Change Overlay Body Outline Height
    // Only because iPhone 7 Plus has an extra control we cant turn off
    
    func cameraToggled(device: UIImagePickerController.CameraDevice) {
        if let frontImage = frontImage {
            let platformString = platform()
            UIView.animate(withDuration: 0.40, animations: {
                switch device {
                case .front:
                    frontImage.frame = CGRect(x: 10.0, y: 10.0, width: self.bounds.width - 20.0, height: self.bounds.height - 20.0)
                    break
                case .rear:
                    frontImage.frame = CGRect(x: 10.0, y: 10.0, width: self.bounds.width - 20.0, height: self.bounds.height - ((platformString == "iPhone9,4") ? 70.0 : 20.0))
                    break
                }
            })
        }
    }
    
    // MARK: Fade Out Outline
    
    func fadeOutOutlineImage() {
        UIView.animate(withDuration: 0.2, delay: 10, options: .curveLinear, animations: {
            self.frontImage?.layer.opacity = 0.0
        }, completion: nil)
    }
}
