//
//  SliderTicks.swift
//  View2Lose
//
//  Created by Sagar on 14/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct SliderTick: UIViewRepresentable {
    var xPos: CGFloat = 100
      var yPos: CGFloat = 0
      var tickWidth: CGFloat = 0
    
    func makeUIView(context: Context) -> UIView {
        let tickView = TickView()
        tickView.xPos = self.xPos
        tickView.yPos = self.yPos
        tickView.tickWidth = self.tickWidth
        return tickView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    
    
}

class TickView: UIView {
    var xPos: CGFloat = 0
    var yPos: CGFloat = 0
    var tickWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let numberOfTick = 11
        let tickView = UIView()
        tickView.backgroundColor = UIColor.black
        tickView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        for i in ( 0 ... numberOfTick ) {
            if i == 0 {
                xPos += tickWidth
                continue
            }
            let tick = UIView(frame: CGRect(x: xPos, y: yPos, width: 1, height: 10))
            tick.backgroundColor = UIColor.black
            tickView.insertSubview(tick, belowSubview: self)
            xPos += tickWidth
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
