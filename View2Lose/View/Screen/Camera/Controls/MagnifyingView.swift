//
//  MagnifyingView.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/8/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

enum MagViewType {
    case round, square, square_BOTTOM
}

class MagnifyingView: UIView
{
    let screenSize = UIScreen.main.bounds
    
    var magType: MagViewType = .round
    weak var imageToMagnify: UIView?
    
    var touchPoint: CGPoint = CGPoint.zero {
        didSet {
            switch magType {
            case .round:
                self.frame = CGRect(x: touchPoint.x - 50.0, y: touchPoint.y - 126.0, width: 100.0, height: 100.0)
                break
            case .square:
                self.frame = CGRect(x: 0, y: touchPoint.y, width: screenSize.width, height: 150.0)
                break
            case .square_BOTTOM:
                self.frame = CGRect(x: 0, y: touchPoint.y - 150.0, width: screenSize.width, height: 150.0)
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    required init(frame: CGRect, type: MagViewType)
    {
        super.init(frame: frame)
        magType = type
        
        switch type {
        case .round:
            self.layer.cornerRadius = 50.0
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.layer.borderWidth = 1
            self.layer.masksToBounds = true
            break
        case .square, .square_BOTTOM:
            break
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.frame.size.width/2, y: self.frame.size.height/2)
        context.scaleBy(x: 2.0, y: 2.0)
        
        switch magType {
        case .round:
            context.translateBy(x: -self.touchPoint.x, y: -self.touchPoint.y + 77.0)
            break
        case .square:
            // Show Middle Of Image
            context.translateBy(x: -screenSize.width/2, y: -self.touchPoint.y - 38.0)
            break
        case .square_BOTTOM:
            // Show Middle Of Image
            context.translateBy(x: -screenSize.width/2, y: -self.touchPoint.y + 38.0)
            break
        }
        
        context.interpolationQuality = CGInterpolationQuality.medium
        self.imageToMagnify!.layer.render(in: context)
    }
}
