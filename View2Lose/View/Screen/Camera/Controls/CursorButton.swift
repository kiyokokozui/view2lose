//
//  CursorButton.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/8/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit

/*
 
 TickandLabel(position: 0, rangeLabel: self.$rangleLabel[(0+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 1, rangeLabel: self.$rangleLabel[(1+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 2, rangeLabel: self.$rangleLabel[(2+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 3, rangeLabel: self.$rangleLabel[(3+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 4, rangeLabel: self.$rangleLabel[(4+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 5, rangeLabel: self.$rangleLabel[(5+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 6, rangeLabel: self.$rangleLabel[(6+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 7, rangeLabel: self.$rangleLabel[(7+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 8, rangeLabel: self.$rangleLabel[(8+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 9, rangeLabel: self.$rangleLabel[(9+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 10, rangeLabel: self.$rangleLabel[(10+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 11, rangeLabel: self.$rangleLabel[(11+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 12, rangeLabel: self.$rangleLabel[(12+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
           TickandLabel(position: 13, rangeLabel: self.$rangleLabel[(13+1)/2], isUSMetric: self.$isUSMetric)
           Spacer()
 */

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
                self.alpha = 0.4
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
            self.setImage(UIImage(named: "right"), for: UIControl.State())
            self.setImage(UIImage(named: "right"), for: .highlighted)
            break
        }
    }
}
