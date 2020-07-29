//
//  UpdateWeight.swift
//  View2Lose
//
//  Created by Jason on 28/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

struct UpdateMeasurement: View {
    @ObservedObject var userGoal = UserGoal()
    
    @State var weightTickRange: [Float] = [0,20,40,60,80,100, 120]
    @State var poundWeightTickRange: [Float] = [0, 50, 100, 150, 200, 250,300]
    @State private var desiredWeightRange: (Double, Double) = (1, 6)
    @State private var currentWeightRange: (Double, Double) = (0, 120)
    @State private var currentpoundWeightRange: (Double, Double) = (0, 300)
    
    @State private var currentWeight: Double = 70
    @State private var currentPoundWeight: Double = 140
    
    @State var waistTickRange: [Float] = [0,20,40,60,80,100, 120]
    @State var poundWaistTickRange: [Float] = [0, 50, 100, 150, 200, 250,300]
    @State private var desiredWaistRange: (Double, Double) = (1, 6)
    @State private var currentWaistRange: (Double, Double) = (0, 120)
    @State private var currentpoundWaistRange: (Double, Double) = (0, 300)
    
    @State private var currentWaist: Double = 70
    @State private var currentPoundWaist: Double = 140
    
    var body: some View {
        VStack (alignment: .leading, spacing: 25) {
            
            VStack (alignment: .leading, spacing: 10) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .foregroundColor(Color("primary"))
                    .padding()
                    .frame(width: 45, height: 50)
                    
                            
                Text("Manual measurement update")
                    .bold()
                    .font(.title)
                    .padding()
            }
                 
            VStack {
                HStack (spacing: 5) {
                    Text("My last weight is")
                        .foregroundColor(Color("primary"))
                        .font(.body)
                    
                    Spacer()
                    
                    Text("65kg")
                        .foregroundColor(Color("primary"))
                        .font(.body)
                }
                
                HStack (spacing: 5) {
                    Text("My last weight is")
                        .foregroundColor(Color(.gray))
                        .font(.body)
                    
                    Spacer()
                    
                    Text("\(Int(userGoal.switchMetric ? self.currentWeight : self.currentPoundWeight)) \(userGoal.switchMetric ? "Kg" : "lb")")                        .foregroundColor(Color("secondary"))
                }
                
                SliderView(percentage: userGoal.switchMetric ? self.$currentWeight : self.$currentPoundWeight, hideTicker: false, range: self.userGoal.switchMetric ? self.currentWeightRange: currentpoundWeightRange, rangleLabel:(self.userGoal.switchMetric ?  self.$weightTickRange : self.$poundWeightTickRange) ).frame( height: 20)
                .padding(.bottom, 40)
            }.padding()
                        
            VStack {
                HStack (spacing: 5) {
                    Text("My last weight is")
                        .foregroundColor(Color("primary"))
                        .font(.body)
                    
                    Spacer()
                    
                    Text("65kg")
                        .foregroundColor(Color("primary"))
                        .font(.body)
                }
                
                HStack (spacing: 5) {
                    Text("My last weight is")
                        .foregroundColor(Color(.gray))
                        .font(.body)
                    
                    Spacer()
                    
                    Text("\(Int(userGoal.switchMetric ? self.currentWaist : self.currentPoundWaist)) \(userGoal.switchMetric ? "cm" : "inches")")                        .foregroundColor(Color("secondary"))
                }
                
                SliderView(percentage: userGoal.switchMetric ? self.$currentWaist : self.$currentPoundWaist, hideTicker: false, range: self.userGoal.switchMetric ? self.currentWaistRange: currentpoundWaistRange, rangleLabel:(self.userGoal.switchMetric ?  self.$waistTickRange : self.$poundWaistTickRange) ).frame( height: 20)
                .padding(.bottom, 40)
            }.padding()
            
            Spacer()

            Button(action: {
               // self.facebookManager.isUserAuthenticated = .cameraOnboard
                //DashboardView()
            }, label: {
                    Text("I am ready!")
                        .padding()
                        .foregroundColor(.white)
                        .modifier(CustomBoldBodyFontModifier(size: 20))

                    .frame(maxWidth: .infinity, alignment: .center)
            })
            .background(Color("primary"))
                .cornerRadius(30)
            .shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
            
        }.padding()
    }
}


struct UpdateMeasurement_Previews: PreviewProvider {
    static var previews: some View {
        UpdateMeasurement()
    }
}
