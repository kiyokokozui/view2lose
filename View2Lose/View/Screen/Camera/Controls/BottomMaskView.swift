//
//  BottomMaskView.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/26/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

class BottomMaskView: UIView
{
    let screenSize = UIScreen.main.bounds
    let stringLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 5, width: 100.0, height: 20.0))
    
    var touchPoint: CGPoint = CGPoint.zero {
        didSet {
            self.frame = CGRect(x: 0, y: touchPoint.y, width: screenSize.width, height:  screenSize.height -  touchPoint.y)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    required  override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.layer.backgroundColor = UIColor(red: 138/255.0, green: 77/255.0, blue: 177/255.0, alpha: 1.0).cgColor
        self.layer.opacity = 0.8
        self.isUserInteractionEnabled = false
        
        // Draw Red Seperator Line
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255.0/255.0, alpha: 1.0).withAlphaComponent(0.9).cgColor;
        lineLayer.lineWidth = 1.0;
        self.layer.addSublayer(lineLayer)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 70.0, y: 0.0))
        path.addLine(to: CGPoint(x: screenSize.width, y: 0.0))
        path.close()
        lineLayer.path = path.cgPath
        
        // Place "Bottom of Feet" Label
        stringLabel.font = UIFont(name: "Helvetica", size: 11.0)
        stringLabel.backgroundColor = UIColor.clear
        stringLabel.text = "Bottom of Feet"
        stringLabel.textColor = UIColor.white
        
        var tempFrame = stringLabel.frame
        tempFrame.origin.x = ((screenSize.width - 90.0) / 2.0 - 50.0) + 90.0
        stringLabel.frame = tempFrame
        self.addSubview(stringLabel)
    }
}
