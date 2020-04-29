//
//  SliderView.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct SliderView: View {
    @Binding var percentage: Double
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var hideTicker: Bool
    
 
    @State var range: (Double, Double) = (40, 120)
    @State private var knobWidth: CGFloat?
    
    
    var body: some View {
        
        GeometryReader  { geometry in
            ZStack(alignment: .leading) {
                
                
                
                Rectangle()
                    .frame(width: geometry.size.width , height: 7)
                    .foregroundColor(Color.init(#colorLiteral(red: 0.8581427932, green: 0.822361052, blue: 0.9280666709, alpha: 1)))
                    .cornerRadius(3)
                
                ZStack (alignment: .trailing) {
                    
                    ZStack(alignment: .center) {
                        
                        
                        Circle()
                            .overlay(
                                Circle()
                                    .stroke(Color(#colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1)).opacity(0.5), style: StrokeStyle(lineWidth: 8))
                        )
                            
                            .foregroundColor(Color("primary"))
                            
                            .frame(width: 14 , height: 14)
                        
                    }
                    
                    
                    Rectangle()
                        .frame(width: self.getOffsetX(frame: geometry.frame(in:.local)), height: 7)
                        .foregroundColor(Color("primary"))
                        .cornerRadius(3)
                }
                    
                .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in

                    self.onDragChange(value, geometry.frame(in: .global))
                }))
                
            }.padding(.bottom, 5)
            
            TickerView(isHidden: self.hideTicker)
                .frame(width: geometry.size.width - 10)
                .padding(.horizontal, 5)


        }
    
    }
    
    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        self.percentage = Double(value)
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width + 20)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
       let result = self.percentage.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
}

struct SliderViewWithBinding: View {
    @Binding var percentage: Double
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var hideTicker: Bool
    @Binding var position: Double
 
    @State private var range: (Double, Double)
    
    @State private var knobWidth: CGFloat?
    

    
    
    var body: some View {
        
        GeometryReader  { geometry in
            ZStack(alignment: .leading) {
                
                
                
                Rectangle()
                    .frame(width: geometry.size.width , height: 7)
                    .foregroundColor(Color.init(#colorLiteral(red: 0.8581427932, green: 0.822361052, blue: 0.9280666709, alpha: 1)))
                    .cornerRadius(3)
                
                ZStack (alignment: .trailing) {
                    
                    ZStack(alignment: .center) {
                        
                        
                        Circle()
                            .overlay(
                                Circle()
                                    .stroke(Color(#colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1)).opacity(0.5), style: StrokeStyle(lineWidth: 8))
                        )
                            
                            .foregroundColor(Color("primary"))
                            
                            .frame(width: 14 , height: 14)
                        
                    }
                    
                    
                    Rectangle()
                        .frame(width: self.getOffsetX(frame: geometry.frame(in:.local)), height: 7)
                        .foregroundColor(Color("primary"))
                        .cornerRadius(3)
                }
                    
                .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in

                    self.onDragChange(value, geometry.frame(in: .global))
                }))
                
            }.padding(.bottom, 5)
            
            TickerView(isHidden: self.hideTicker)
                .frame(width: geometry.size.width - 10)
                .padding(.horizontal, 5)


        }
    
    }
    
    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) {

        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        self.percentage = Double(value)
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width + 20)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
       let result = self.percentage.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
}

struct TickerView: View {
    let ticks: Int = 11
    @State var isHidden : Bool
    var body: some View {
        HStack {
            if !isHidden {
                createTicker()
            }
        }
    }
    
     func createTicker() -> some View {

        return HStack (alignment: .center) {
           ForEach(0..<ticks){ i in
            self.createLargeTicks(postion: i)
            if i != (self.ticks-1) {
                Spacer()

            }
           }
        }
    }
    
     func createLargeTicks(postion: Int) -> some View {
        if postion % 2 == 0 {
            return Rectangle().frame(width: 1, height: 9).offset(y: 20).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1)))
        } else {
            return Rectangle().frame(width: 1, height: 4).offset(y: 20).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1)))
        }
        
    }
   
}

struct TickerView2: View {
    let ticks: Int = 11
    @State var isHidden : Bool
    var body: some View {
        HStack {
            if !isHidden {
                createTicker()
            }
        }
    }
    
     func createTicker() -> some View {

        return HStack (alignment: .center) {
           ForEach(0..<4){ i in
            //self.createLargeTicks(postion: i)
            Text("Week \(i)").font(.caption).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1))).padding(.top, 20)
            if i != (self.ticks-1) {
                Spacer()

            }
           }
        }
    }
    
     func createLargeTicks(postion: Int) -> some View {
        if postion % 2 == 0 {
            return Rectangle().frame(width: 1, height: 9).offset(y: 20).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1)))
        } else {
            return Rectangle().frame(width: 0, height: 0).offset(y: 20).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1)))
        }
        
    }
   
}



extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}


struct SliderViewDashboard: View {
    @Binding var percentage: Double
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var hideTicker: Bool
    
 
    @State var range: (Double, Double) = (40, 120)
    @State private var knobWidth: CGFloat?
    
    
    var body: some View {
        
        GeometryReader  { geometry in
            ZStack(alignment: .leading) {
                
                
                
               Rectangle()
               .frame(width: geometry.size.width , height: 7)
               .foregroundColor(Color.init(#colorLiteral(red: 0.8581427932, green: 0.822361052, blue: 0.9280666709, alpha: 1)))
               .cornerRadius(3)
                
                ZStack (alignment: .trailing) {
                    
                    ZStack(alignment: .center) {
                        Rectangle()
                        .frame(width: self.getOffsetX(frame: geometry.frame(in:.local)), height: 7)
                        .foregroundColor(Color.init(#colorLiteral(red: 0.8581427932, green: 0.822361052, blue: 0.9280666709, alpha: 1)))
                        .cornerRadius(3)
                        
                        Circle()
                            .overlay(
                                Circle()
                                    .stroke(Color(#colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1)).opacity(0.5), style: StrokeStyle(lineWidth: 8))
                        )
                            
                            .foregroundColor(Color("primary"))
                            
                            .frame(width: 14 , height: 14)
                        
                    }
                    
                    
                    
                }
                    
                    
                .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in

                    self.onDragChange(value, geometry.frame(in: .global))
                }))
                
            }.padding(.bottom, 5)
            
            TickerView2(isHidden: self.hideTicker)
                .frame(width: geometry.size.width - 10)
                .padding(.horizontal, 5)


        }
    
    }
    
    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        self.percentage = Double(value)
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width + 20)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
       let result = self.percentage.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
}
