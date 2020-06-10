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
                self.frame = CGRect(x: touchPoint.x - 90.0, y: touchPoint.y - 93.0, width: 90.0, height: 34.0)
            case .right:
                self.frame = CGRect(x: touchPoint.x, y: touchPoint.y - 93.0, width: 90.0, height: 34.0)
            }
        }
    }
    
    convenience init(withSide: NavelSide)
    {
        self.init(frame: CGRect.zero)
        self.side = withSide
        
        switch self.side {
        case .left:
            self.image = UIImage(named: "marker_left_navel")
        case .right:
            self.image = UIImage(named: "marker_right_navel")
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
