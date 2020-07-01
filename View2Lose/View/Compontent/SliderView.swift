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
    
 
    @State  var range: (Double, Double) = (40, 120)
    @State private var knobWidth: CGFloat?
    @Binding var rangleLabel : [Float]
    
    @State var isUSMetric: Bool = true
    
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
            
            TickerView(isHidden: self.hideTicker, rangleLabel: self.$rangleLabel, isUSMetric: self.$isUSMetric)
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
struct SliderViewBinding: View {
    @Binding var percentage: Double
 
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var hideTicker: Bool
    
 
    @Binding  var range: (Double, Double)
    @State private var knobWidth: CGFloat?
    @Binding var rangleLabel : [Float]
    @Binding var isUSMetric : Bool

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
            
            TickerView(isHidden: self.hideTicker, rangleLabel: self.$rangleLabel, isUSMetric: self.$isUSMetric)
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
    @Binding var maxNumber: Double
     @Binding var minNumber : Double
    
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var hideTicker: Bool
    //@Binding var position: Double
 @Binding var isUSMetric : Bool

    @Binding var rangleLabel : [Float]

    @State private var knobWidth: CGFloat?
    
//    init(percentage: Double, maxNumber: Double, minNumber: Double, hideTicker: Bool) {
//        self.percentage = percentage
//        self.maxNumber = maxNumber
//        self.minNumber = minNumber
//        self.hideTicker = hideTicker
//
//
//    }
   
    
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
            
            TickerView(isHidden: self.hideTicker, rangleLabel: self.$rangleLabel, isUSMetric: self.$isUSMetric)                .frame(width: geometry.size.width - 10)
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
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: (minNumber, maxNumber))
        self.percentage = Double(value)
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width + 20)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
       let result = self.percentage.convert(fromRange: (minNumber, maxNumber), toRange: xrange)
        return CGFloat(result)
    }
}

struct TickerView: View {
    var ticks: Int = 13
    @State var isHidden : Bool
    @Binding var rangleLabel : [Float]
    @Binding var isUSMetric : Bool
    @EnvironmentObject var userInfo : UserBasicInfo

    var body: some View {
        HStack {
         //   if !isHidden {
                //createTicker()
            HStack (alignment: .center) {
//               ForEach(0 ..< ticks){ i in
//
//                //self.createLargeTicks(postion: i)
//                //print(i)
//                TickandLabel(position: i, rangeLabel: self.$rangleLabel[(i+1)/2], isUSMetric: self.$isUSMetric)
//                //Text("\(self.rangleLabel[1], specifier: "%.1f")")
//                if i != (self.ticks-1) {
//                    Spacer()
//
//                }
                Group {
                    Group {
                        TickandLabel(position: 0, rangeLabel: self.$rangleLabel[(0+1)/2], isUSMetric: self.$isUSMetric)
                        Spacer()
                        TickandLabel(position: 1, rangeLabel: self.$rangleLabel[(1+1)/2], isUSMetric: self.$isUSMetric)
                        Spacer()
                        TickandLabel(position: 2, rangeLabel: self.$rangleLabel[(2+1)/2], isUSMetric: self.$isUSMetric)
                        Spacer()
                        TickandLabel(position: 3, rangeLabel: self.$rangleLabel[(3+1)/2], isUSMetric: self.$isUSMetric)
                        Spacer()

                    }
                    
                    Group {
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
//                        TickandLabel(position: 9, rangeLabel: self.$rangleLabel[(9+1)/2], isUSMetric: self.$isUSMetric)
//                        Spacer()
                    }
                    
                    Group {
                        TickandLabel(position: 9, rangeLabel: self.$rangleLabel[(9+1)/2], isUSMetric: self.$isUSMetric)
                        Spacer()
                        TickandLabel(position: 10, rangeLabel: self.$rangleLabel[(10+1)/2], isUSMetric: self.$isUSMetric)
                        Spacer()
                        TickandLabel(position: 11, rangeLabel: self.$rangleLabel[(11+1)/2], isUSMetric: self.$isUSMetric)
                        Spacer()
                        TickandLabel(position: 12, rangeLabel: self.$rangleLabel[(12+1)/2], isUSMetric: self.$isUSMetric)
                    }
                }
               }
            }
          //  }
        }
    
    
    

    
     func createLargeTicks(postion: Int) -> some View {
      
            return VStack(alignment: .center) {
                Rectangle().frame(width: 1, height: 9).offset(y: 20).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1))).padding(10)
                Text("0")
            }
            
            
     
           // return Rectangle().frame(width: 1, height: 4).offset(y: 20).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1)))
     
    }
    
    func createTickLabel(position: Int) -> some View {
        if position % 2 == 0 {
            return Text("0").foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1)))
        } else {
            return Text("")
        }
    }
   
}

struct TickandLabel: View {
    @State var position: Int
    @Binding  var rangeLabel: Float
    @Binding var isUSMetric: Bool
    var body: some View {
        VStack {
            Rectangle().frame(width: 1, height: self.position % 2 == 0 ? 9 : 4).offset(y: 20).foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1)))
                .padding(.bottom, 10)
            if isUSMetric {
                createTickLabel(position: self.position, positionlabel: rangeLabel)

            } else {
                createUSTickLabel(position: self.position, positionlabel: rangeLabel)

            }
            
            

        }
        
    }
    
    func createTickLabel(position: Int, positionlabel: Float) -> some View {
        Text(position % 2 == 0 ? "\(positionlabel, specifier: "%.0f")" : "").foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1))).font(.system(size: 11)).padding(.top, 5)

    }
    
    func createUSTickLabel(position: Int, positionlabel: Float) -> some View {
        Text(position % 2 == 0 ? "\(positionlabel, specifier: "%.1f")" : "").foregroundColor(Color(#colorLiteral(red: 0.7304339409, green: 0.7245418429, blue: 0.7541612387, alpha: 1))).font(.system(size: 11)).padding(.top, 5)

    }
}



struct TickerView2: View {
    let ticks: Int = 13
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

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
