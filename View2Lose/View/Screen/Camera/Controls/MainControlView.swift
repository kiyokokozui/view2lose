//
//  MainControlView.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/27/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

struct Measurements {
    var frontSet: Bool = false
    var sideSet: Bool = false
    
    var frontTop: CGFloat = -1.0
    var frontLeftX: CGFloat = -1.0
    var frontLeftY: CGFloat = -1.0
    var frontBottom: CGFloat = -1.0
    var frontRightX: CGFloat = -1.0
    var frontRightY: CGFloat = -1.0
    var sideTop: CGFloat = -1.0
    var sideLeft: CGFloat = -1.0
    var sideBottom: CGFloat = -1.0
    var sideRight: CGFloat = -1.0    
}

struct BodyImages {
    var frontImage: UIImage?
    var sideImage: UIImage?
}

enum PhotoType {
    case front, side
}

protocol ControlViewDelegate: class {
    func newMeasurements(_ top: CGFloat, leftX: CGFloat, leftY: CGFloat, bottom: CGFloat, rightX: CGFloat, rightY: CGFloat)
}

// Cursor Size Constants
let cursorTopBottomSize: CGFloat = 60.0
let cursorLeftRightSize: CGFloat = 70.0
let cursorMarginSize: CGFloat = 20.0

public class MainControlView: UIView
{
    weak var delegate: ControlViewDelegate?
    //public var imageName: String = "com.smr.front.png"
    
    var imageView: UIImageView?
    {
        didSet {
            magGlassLeft.imageToMagnify = imageView
            magGlassRight.imageToMagnify = imageView
            magGlassTop.imageToMagnify = imageView
            magGlassBottom.imageToMagnify = imageView
        }
    }

    var cursorButtonLeft: CursorButton = CursorButton(frame: CGRect.zero, type: .free)
    var cursorButtonRight: CursorButton = CursorButton(frame: CGRect.zero, type: .free)
    var cursorButtonTop: CursorButton = CursorButton(frame: CGRect.zero, type: .vertical)
    var cursorButtonBottom: CursorButton = CursorButton(frame: CGRect.zero, type: .vertical)
    
    var cursorPanLeft: UIPanGestureRecognizer?
    var cursorPanRight: UIPanGestureRecognizer?
    var cursorPanTop: UIPanGestureRecognizer?
    var cursorPanBottom: UIPanGestureRecognizer?
    
    var supportLoupe: Bool = false
    //var supportedHardwareSet = Set<Hardware>()
    var magGlassLeft: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .round)
    var magGlassRight: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .round)
    var magGlassTop: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .square)
    var magGlassBottom: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .square_BOTTOM)
    
    var indicatorViewLeft: IndicatorView = IndicatorView(withSide: .left)
    var indicatorViewRight: IndicatorView = IndicatorView(withSide: .right)
    
    var topMask: TopMaskView = TopMaskView()
    var bottomMask: BottomMaskView = BottomMaskView()
    
    let screenSize = UIScreen.main.bounds
    var lineLayer = CAShapeLayer()
    var imageHeight: CGFloat = 0.0
    var imageSizeScreenOffset: CGFloat = 0.0
    
    var initialSubviewLayout: Bool = false
    
   
    
    
    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        let scaleFactor1 = 4.0/3.0

        let newHeight = sourceImage.size.height * CGFloat(scaleFactor1)
        let newWidth = oldWidth

        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
    }
    private func getDocumentsDirectory() -> NSString {
              let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
              let documentsDirectory = paths[0]
              return documentsDirectory as NSString
    }
    
    required init(imageName: String) {
        super.init(frame: CGRect.zero)
        
        self.imageView = UIImageView()
           let filename = getDocumentsDirectory().appendingPathComponent(imageName)
           if let image = UIImage(contentsOfFile: filename) {
               self.imageView!.image = imageWithImage(sourceImage: image, scaledToWidth: 0.3)
       
           }
           
           self.imageView!.translatesAutoresizingMaskIntoConstraints = false
           //self.imageView?.frame.size.height = screenSize.size.height / (4/3)
           //self.imageView?.contentMode = .scaleAspectFit

           addSubview(self.imageView!)
           self.imageView!.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
           self.imageView!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
           self.imageView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
           self.imageView!.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
           //self.imageView?.heightAnchor.constraint(equalToConstant: 500).isActive = true
          // self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
           
           let cameraAspectRatio = CGFloat(4.0/3.0)
          imageHeight = screenSize.width * cameraAspectRatio
          imageSizeScreenOffset = (screenSize.size.height - imageHeight) / 2.0
           // Setup Hack Check Because Of Poor Performance On Old Devices With Loupe Effect
          //setupSupportedHardwareSet()
          supportLoupe = false //shouldSupportLoupeEffect(DeviceUtil.hardware())
           self.initialSubviewLayout = true

          
          

          
          setupViewAndControls()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.initialSubviewLayout {
            self.initialSubviewLayout = false
            // Top Cursor & Mask
            cursorButtonTop.frame = CGRect(x: 10.0, y: 20.0, width: cursorTopBottomSize, height: cursorTopBottomSize)
            topMask.touchPoint = CGPoint(x: 0, y: 20.0 + cursorTopBottomSize/2.0)
            // Bottom Cursor & Mask
            cursorButtonBottom.frame = CGRect(x: 10.0, y: self.frame.size.height - cursorTopBottomSize - 20.0, width: cursorTopBottomSize, height: cursorTopBottomSize)
            bottomMask.touchPoint = CGPoint(x: 0, y: self.frame.size.height - cursorTopBottomSize/2.0 - 20.0)
            // Left Cursor & Indicator
            cursorButtonLeft.frame = CGRect(x: self.frame.size.width/4.0 - cursorLeftRightSize/2.0, y: self.frame.size.height/2.0 - cursorLeftRightSize/2.0, width: cursorLeftRightSize, height: cursorLeftRightSize)
            cursorButtonLeft.touchPoint = CGPoint(x: cursorButtonLeft.frame.origin.x + cursorLeftRightSize/2.0, y: cursorButtonLeft.frame.origin.y + cursorLeftRightSize/2.0) // This needs set so that first touch of cursor will match other cursors y and not be 0
            indicatorViewLeft.frame = CGRect(x: self.frame.size.width/4.0 - 2, y: self.frame.size.height/2.0 - cursorLeftRightSize - 1.0, width: 4.0, height: 4.0)
            indicatorViewLeft.touchPoint = cursorButtonLeft.touchPoint // This needs set so that first touch of cursor will match other indicators y and not be 0
            // Right Cursor & Indicator
            cursorButtonRight.frame = CGRect(x: self.frame.size.width*(3.0/4.0) - cursorLeftRightSize/2.0, y: self.frame.size.height/2.0 - cursorLeftRightSize/2.0, width: cursorLeftRightSize, height: cursorLeftRightSize)
            cursorButtonRight.touchPoint = CGPoint(x: cursorButtonRight.frame.origin.x + cursorLeftRightSize/2.0, y: cursorButtonRight.frame.origin.y + cursorLeftRightSize/2.0) // This needs set so that first touch of cursor will match other cursors y and not be 0
            indicatorViewRight.frame = CGRect(x: self.frame.size.width*(3.0/4.0) - 2.0, y: self.frame.size.height/2.0 - cursorLeftRightSize - 1.0, width: 4.0, height: 4.0)
            indicatorViewRight.touchPoint = cursorButtonRight.touchPoint // This needs set so that first touch of cursor will match other indicators y and not be 0
            // Draw Connecting Line
            drawLine()
        }
    }
    
    // MARK: Setup View And Controls
    
    func setupViewAndControls() {
        // Top/Bottom Masks
        self.addSubview(topMask)
        self.addSubview(bottomMask)
        
        cursorPanLeft = UIPanGestureRecognizer(target: self, action: #selector(panButton))
        cursorPanRight = UIPanGestureRecognizer(target: self, action: #selector(panButton))
        cursorPanBottom = UIPanGestureRecognizer(target: self, action: #selector(panButton))
        cursorPanTop = UIPanGestureRecognizer(target: self, action: #selector(panButton))
        
        // Left Cursor Button
        cursorButtonLeft.addGestureRecognizer(cursorPanLeft!)
        cursorButtonLeft.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
        cursorButtonLeft.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
        
        self.addSubview(indicatorViewLeft)
        
        // Right Cursor Button
        cursorButtonRight.addGestureRecognizer(cursorPanRight!)
        cursorButtonRight.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
        cursorButtonRight.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
        
        self.addSubview(indicatorViewRight)
        self.addSubview(cursorButtonLeft)
        self.addSubview(cursorButtonRight)
        
        // Bottom Cursor For Feet
        cursorButtonBottom.addGestureRecognizer(cursorPanBottom!)
        cursorButtonBottom.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
        cursorButtonBottom.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
        
        // Top Cursor
        cursorButtonTop.addGestureRecognizer(cursorPanTop!)
        cursorButtonTop.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
        cursorButtonTop.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
        self.addSubview(cursorButtonTop)
        self.addSubview(cursorButtonBottom)
        
        // Set Up Connecting Line
        lineLayer.strokeColor = UIColor.red.withAlphaComponent(0.8).cgColor;
        lineLayer.lineWidth = 1.0;
        self.layer.addSublayer(lineLayer)
        
//        // Top/Bottom Masks
//        topMask.touchPoint = CGPoint(x: 0.0, y: 40.0) // Y = Top Cursor Y (Center)
//        bottomMask.touchPoint = CGPoint(x: 0.0, y: screenSize.height - 40.0 - 64.0) // Bottom Cursor Y (Center) (Has 64 Yoffset From Nav Bar)
//        self.addSubview(topMask)
//        self.addSubview(bottomMask)
//        
//        cursorPanLeft = UIPanGestureRecognizer(target: self, action: #selector(panButton))
//        cursorPanRight = UIPanGestureRecognizer(target: self, action: #selector(panButton))
//        cursorPanBottom = UIPanGestureRecognizer(target: self, action: #selector(panButton))
//        cursorPanTop = UIPanGestureRecognizer(target: self, action: #selector(panButton))
//        
//        // Left Cursor Button
//        cursorButtonLeft.frame = CGRect(x: screenSize.width/4.0 - 35.0, y: screenSize.height/2.0 - 35.0, width: 70.0, height: 70.0)
//        cursorButtonLeft.addGestureRecognizer(cursorPanLeft!)
//        cursorButtonLeft.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
//        cursorButtonLeft.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
//        indicatorViewLeft.frame = CGRect(x: screenSize.width/4.0 - 90.0, y: screenSize.height/2.0 - 93.0, width: 90.0, height: 34.0)
//        self.addSubview(indicatorViewLeft)
//        
//        // Right Cursor Button
//        cursorButtonRight.frame = CGRect(x: screenSize.width*(3.0/4.0) - 35.0, y: screenSize.height/2.0 - 35.0, width: 70.0, height: 70.0)
//        cursorButtonRight.addGestureRecognizer(cursorPanRight!)
//        cursorButtonRight.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
//        cursorButtonRight.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
//        
//        indicatorViewRight.frame = CGRect(x: screenSize.width*(3.0/4.0), y: screenSize.height/2.0 - 93.0, width: 90.0, height: 34.0)
//        self.addSubview(indicatorViewRight)
//        self.addSubview(cursorButtonLeft)
//        self.addSubview(cursorButtonRight)
//        
//        // Bottom Cursor For Feet
//        cursorButtonBottom.frame = CGRect(x: 10.0, y: screenSize.height - 40.0 - 64.0 - 30.0, width: 60.0, height: 60.0)
//        cursorButtonBottom.addGestureRecognizer(cursorPanBottom!)
//        cursorButtonBottom.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
//        cursorButtonBottom.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
//        
//        // Top Cursor
//        cursorButtonTop.frame = CGRect(x: 10.0, y: 10.0, width: 60.0, height: 60.0)
//        cursorButtonTop.addGestureRecognizer(cursorPanTop!)
//        cursorButtonTop.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
//        cursorButtonTop.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
//        self.addSubview(cursorButtonTop)
//        self.addSubview(cursorButtonBottom)
//        
//        // Set Up Connecting Line
//        lineLayer.strokeColor = UIColor(colorLiteralRed: 175/255.0, green: 0.0, blue: 17/255.0, alpha: 1.0).withAlphaComponent(0.8).cgColor;
//        lineLayer.lineWidth = 1.0;
//        self.layer.addSublayer(lineLayer)
//        drawLine()
    }
    
    func resetControls() {
        func resetControls() {
            self.initialSubviewLayout = true
            self.setNeedsLayout()
        }
    }
    
    // MARK: Magnifying Glass Methods
    
    fileprivate func addMagnifyingGlass(_ magGlass: MagnifyingView, atPoint point: CGPoint, forCursor cursor: CursorButton) {
        var currentIndicator = indicatorViewLeft
        if magGlass === magGlassRight {
            currentIndicator = indicatorViewRight
        }
        magGlass.touchPoint = point
        self.insertSubview(magGlass, belowSubview: currentIndicator)
        
        magGlass.setNeedsDisplay()
    }
    
    fileprivate func updateMagnifyingGlass(_ magGlass: MagnifyingView, atPoint point: CGPoint) {
        magGlass.touchPoint = point
        magGlass.setNeedsDisplay()
    }
    
    fileprivate func removeMagnifyingGlass(_ magGlass: MagnifyingView) {
        magGlass.removeFromSuperview()
    }
    
    // MARK: Update Cursor Button
    
    fileprivate func updateCursorButtonAtPoint(_ point: CGPoint, cursor: CursorButton) {
        // Update Masks If Needed
        if cursor === cursorButtonTop {
            topMask.touchPoint = point
            topMask.setNeedsDisplay()
        } else if cursor === cursorButtonBottom {
            bottomMask.touchPoint = point
            bottomMask.setNeedsDisplay()
        } else if (cursor === cursorButtonLeft) {
            // Left Cursor
            // We need to match y for each
            cursorButtonRight.touchPoint.y = point.y
            cursorButtonRight.setNeedsDisplay()
        } else {
            // Right Cursor
            // We need to match y for each
            cursorButtonLeft.touchPoint.y = point.y
            cursorButtonLeft.setNeedsDisplay()
        }
        cursor.touchPoint = point
        cursor.setNeedsDisplay()
    }
    
    // MARK: Update Indicator
    
    fileprivate func updateIndicatorAtPoint(_ point: CGPoint, indicator: IndicatorView) {
        indicator.touchPoint = point
        indicator.setNeedsDisplay()
        if (indicator === indicatorViewLeft) {
            // Match right y
            self.indicatorViewRight.touchPoint.y = point.y
            self.indicatorViewRight.setNeedsDisplay()
        } else {
            // Match left y
            self.indicatorViewLeft.touchPoint.y = point.y
            self.indicatorViewLeft.setNeedsDisplay()
        }
    }
    
    // MARK: Get Documents Directory
    
  
    
    // MARK: Button Down
    
    @IBAction func loupeButtonDown(_ sender: UIButton) {
        var currentMagGlass = magGlassLeft
        if sender === cursorButtonRight {
            currentMagGlass = magGlassRight
        } else if sender === cursorButtonTop {
            currentMagGlass = magGlassTop
        } else if sender === cursorButtonBottom {
            currentMagGlass = magGlassBottom
        }
        
        // If We Are On An Older Device, The Scaling Of The Image Is Poop
        // Trying To Filter Out This Functionality For Older Devices For Now
        if supportLoupe {
            addMagnifyingGlass(currentMagGlass, atPoint: sender.center, forCursor: sender as! CursorButton)
        }
    }
    
    @IBAction func loupeButtonUp(_ sender: UIButton) {
        var currentMagGlass = magGlassLeft
        if sender === cursorButtonRight {
            currentMagGlass = magGlassRight
        } else if sender === cursorButtonTop {
            currentMagGlass = magGlassTop
        } else if sender === cursorButtonBottom {
            currentMagGlass = magGlassBottom
        }
        removeMagnifyingGlass(currentMagGlass)
    }
    
    // MARK: Pan Gesture From Buttons
    
    @objc func panButton(_ gesture: UIPanGestureRecognizer) {
        let imageBounds = self.imageView!.bounds
        var updatedPt = gesture.location(in: self.imageView)
        var currentMagGlass: MagnifyingView? = magGlassLeft
        var currentIndicator: IndicatorView? = indicatorViewLeft

        if gesture.view! === cursorButtonRight {  // RIGHT
            currentMagGlass = magGlassRight
            currentIndicator = indicatorViewRight
            
            // Restrict Right Cursor (This is the center pt so offset as needed)
            updatedPt.x = max(min(imageBounds.width, updatedPt.x), indicatorViewLeft.center.x)
            updatedPt.y = min(max(updatedPt.y, 78.0), imageBounds.height - 35.0) // 78.0 is indicator offset from cursor center
        } else if gesture.view! === cursorButtonBottom { // BOTTOM
            currentMagGlass = magGlassBottom
            currentIndicator = nil
            
            // Restrict Bottom Cursor (This is the center pt so offset as needed)
            updatedPt.x = 40.0
            updatedPt.y = max(min(updatedPt.y, imageBounds.height - 30.0), imageBounds.height/2)
        } else if gesture.view! === cursorButtonTop { // TOP
            currentMagGlass = magGlassTop
            currentIndicator = nil
            
            // Restrict Top Cursor (This is the center pt so offset as needed)
            updatedPt.x = 40.0
            updatedPt.y = max(min(updatedPt.y, imageBounds.height/2), 30.0)
        } else { // LEFT
            // Restrict Left Cursor (This is the center pt so offset as needed)
            updatedPt.x = min(max(0.0, updatedPt.x), indicatorViewRight.center.x)
            updatedPt.y = min(max(updatedPt.y, 78.0), imageBounds.height - 35.0) // 78.0 is indicator offset crom cursor center
        }
        
        switch gesture.state {
        case .changed:
            if let currentMagGlass = currentMagGlass {
                updateMagnifyingGlass(currentMagGlass, atPoint: updatedPt)
            }
            if let currentIndicator = currentIndicator {
                updateIndicatorAtPoint(updatedPt, indicator: currentIndicator)
            }
            updateCursorButtonAtPoint(updatedPt, cursor: gesture.view as! CursorButton)
            drawLine()
            break
        case .ended:
            if let currentMagGlass = currentMagGlass {
                removeMagnifyingGlass(currentMagGlass)
            }
            break
        default: ()
        }
        updateMeasurements()
        print("Position: (\(cursorButtonTop.center.y),\(indicatorViewLeft.center.x + 45.0),\(indicatorViewLeft.center.y),\(cursorButtonBottom.center.y),\(indicatorViewRight.center.x - 45.0),\(indicatorViewRight.center.y))")
    }
    
    // Draw Connecting Line
    
    func drawLine() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: indicatorViewLeft.center.x + 45.0, y: indicatorViewLeft.center.y))
        path.addLine(to: CGPoint(x: indicatorViewRight.center.x - 45.0, y: indicatorViewRight.center.y))
        path.close()
        
        lineLayer.path = path.cgPath
    }
    
    // Update Measurements
    
    func updateMeasurements() {
        if let delegate = self.delegate {
            delegate.newMeasurements(cursorButtonTop.center.y,
                                     leftX: indicatorViewLeft.center.x + 45.0,
                                     leftY:  indicatorViewLeft.center.y,
                                     bottom: cursorButtonBottom.center.y,
                                     rightX: indicatorViewRight.center.x - 45.0,
                                     rightY: indicatorViewRight.center.y)
        }
    }
    
    // MARK: Setup Supported Hardware Set
    
//    func setupSupportedHardwareSet() {
//        supportedHardwareSet.insert(Hardware.IPHONE_5C)
//        supportedHardwareSet.insert(Hardware.IPHONE_5C_CDMA_GSM)
//        supportedHardwareSet.insert(Hardware.IPHONE_5S)
//        supportedHardwareSet.insert(Hardware.IPHONE_5S_CDMA_GSM)
//        supportedHardwareSet.insert(Hardware.IPHONE_6_PLUS)
//        supportedHardwareSet.insert(Hardware.IPHONE_6)
//        supportedHardwareSet.insert(Hardware.IPHONE_6S)
//        supportedHardwareSet.insert(Hardware.IPHONE_6S_PLUS)
//        supportedHardwareSet.insert(Hardware.IPHONE_SE)
//        supportedHardwareSet.insert(Hardware.IPOD_TOUCH_6G)
//        supportedHardwareSet.insert(Hardware.IPAD_2_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_2)
//        supportedHardwareSet.insert(Hardware.IPAD_2_CDMA)
//        supportedHardwareSet.insert(Hardware.IPAD_2)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_WIFI_CDMA)
//        supportedHardwareSet.insert(Hardware.IPAD_3_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_3_WIFI_CDMA)
//        supportedHardwareSet.insert(Hardware.IPAD_3)
//        supportedHardwareSet.insert(Hardware.IPAD_4_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_4)
//        supportedHardwareSet.insert(Hardware.IPAD_4_GSM_CDMA)
//        supportedHardwareSet.insert(Hardware.IPAD_AIR_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_AIR_WIFI_GSM)
//        supportedHardwareSet.insert(Hardware.IPAD_AIR_WIFI_CDMA)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_RETINA_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_RETINA_WIFI_CDMA)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_RETINA_WIFI_CELLULAR_CN)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_3_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_3_WIFI_CELLULAR)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_3_WIFI_CELLULAR_CN)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_4_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_MINI_4_WIFI_CELLULAR)
//        supportedHardwareSet.insert(Hardware.IPAD_AIR_2_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_AIR_2_WIFI_CELLULAR)
//        supportedHardwareSet.insert(Hardware.IPAD_PRO_WIFI)
//        supportedHardwareSet.insert(Hardware.IPAD_PRO_WIFI_CELLULAR)
//        supportedHardwareSet.insert(Hardware.SIMULATOR)
//    }
//
//    // MARK: Return Whether This Device Should Support Loupe Effect
//
//    func shouldSupportLoupeEffect(_ device: Hardware) -> Bool {
//        if supportedHardwareSet.contains(device) {
//            return true
//        }
//        return false
//    }
}
