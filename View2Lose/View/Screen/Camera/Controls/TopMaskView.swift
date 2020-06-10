//
//  MaskView.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/26/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

class TopMaskView: UIView {
    let lineLayer = CAShapeLayer()
    let screenSize = UIScreen.main.bounds
    let stringLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100.0, height: 20.0))
    
    var touchPoint: CGPoint = CGPoint.zero {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: touchPoint.y)
            drawLineAndAdjustLabel()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.backgroundColor = UIColor(red: 138/255.0, green: 77/255.0, blue: 177/255.0, alpha: 1.0).cgColor
        self.layer.opacity = 0.8
        self.isUserInteractionEnabled = false
        
        // Draw Red Seperator Line
        lineLayer.strokeColor = UIColor(red: 175/255.0, green: 0.0, blue: 17/255.0, alpha: 1.0).withAlphaComponent(0.8).cgColor;
        lineLayer.lineWidth = 1.0;
        self.layer.addSublayer(lineLayer)
        
        // Place "Top of Head" Label
        stringLabel.font = UIFont(name: "Helvetica", size: 11.0)
        stringLabel.backgroundColor = UIColor.clear
        stringLabel.text = "Top of Head"
        stringLabel.textColor = UIColor.white
        
        // Adjust X
        var tempFrame = stringLabel.frame
        tempFrame.origin.x = ((screenSize.width - 90.0) / 2.0 - 50.0) + 90.0
        stringLabel.frame = tempFrame
        self.addSubview(stringLabel)
    }
    
    func drawLineAndAdjustLabel() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 70.0, y: touchPoint.y))
        path.addLine(to: CGPoint(x: screenSize.width, y: touchPoint.y))
        path.close()
        
        lineLayer.path = path.cgPath
        
        // Adjust Y
        var tempFrame = stringLabel.frame
        tempFrame.origin.y = touchPoint.y - 25.0
        stringLabel.frame = tempFrame
    }
}
