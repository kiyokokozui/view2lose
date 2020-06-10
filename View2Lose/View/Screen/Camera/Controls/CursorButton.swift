//
//  CursorButton.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/8/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

enum CursorType {
    case free, vertical
}

class CursorButton: UIButton {
    var cursorType: CursorType = .free
    var touchPoint: CGPoint = CGPoint.zero {
        didSet {
            switch cursorType {
            case .free:
                self.frame = CGRect(x: touchPoint.x - 35.0, y: touchPoint.y - 35.0, width: 70.0, height: 70.0)
                break
            case .vertical:
                self.frame = CGRect(x: touchPoint.x - 30.0, y: touchPoint.y - 30.0, width: 60.0, height: 60.0)
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(frame: CGRect, type: CursorType) {
        super.init(frame: frame)
        self.cursorType = type
        self.showsTouchWhenHighlighted = false
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor.white.cgColor
        
        switch type {
        case .free:
            self.layer.cornerRadius = 35.0
            self.setImage(UIImage(named: "finger_tap"), for: UIControl.State())
            self.setImage(UIImage(named: "finger_tap"), for: .highlighted)
            break
        case .vertical:
            self.layer.cornerRadius = 30.0
            self.setImage(UIImage(named: "vertical_swipe"), for: UIControl.State())
            self.setImage(UIImage(named: "vertical_swipe"), for: .highlighted)
            break
        }
    }
}
