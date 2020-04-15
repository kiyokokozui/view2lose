//
//  SliderView.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct SliderView: View {
    @Binding var percentage: Float
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var hideTicker: Bool
   
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
                        .frame(width: geometry.size.width * CGFloat(self.percentage / 100), height: 7)
                        .foregroundColor(Color("primary"))
                        .cornerRadius(3)
                }
                    
                .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in
                    
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                    
                    
                    
                }))
                
            }.padding(.bottom, 5)
            
            TickerView(isHidden: self.hideTicker)
                .frame(width: geometry.size.width - 15)
                .padding(.horizontal, 5)


        }
    
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
    
    func performOffsetUpdate() {
        
    }
}


