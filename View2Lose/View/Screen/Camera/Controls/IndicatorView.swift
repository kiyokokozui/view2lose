//
//  IndicatorView.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/19/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

enum NavelSide {
    case left, right
}

class IndicatorView: UIImageView
{
    var side: NavelSide = .left
    
    var touchPoint: CGPoint = CGPoint.zero {
        didSet {
            switch side {
            case .left:
                self.frame = CGRect(x: touchPoint.x - 90.0, y: touchPoint.y - 93.0, width: 70, height: 26)
            case .right:
                self.frame = CGRect(x: touchPoint.x, y: touchPoint.y - 93.0, width: 70, height: 26)
            }
        }
    }
    
    convenience init(withSide: NavelSide)
    {
        self.init(frame: CGRect.zero)
        self.side = withSide
        contentMode = .scaleAspectFit
        self.tintColor = .white

        switch self.side {
        case .left:
            self.image = UIImage(named: "triangle_left")?.withRenderingMode(.alwaysTemplate)
            
        case .right:
            self.image = UIImage(named: "triangle_right")?.withRenderingMode(.alwaysTemplate)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    required  override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.layer.opacity = 0.8
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
