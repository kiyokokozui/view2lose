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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userGoal = UserGoal()
    @EnvironmentObject var facebookManager: FacebookManager
    
    @State var weightTickRange: [Float] = [0,20,40,60,80,100, 120]
    @State var poundWeightTickRange: [Float] = [0, 50, 100, 150, 200, 250,300]
    @State private var desiredWeightRange: (Double, Double) = (1, 6)
    @State private var currentWeightRange: (Double, Double) = (0, 120)
    @State private var currentpoundWeightRange: (Double, Double) = (0, 300)
    
    @State private var currentWeight: Double = UserDefaults.standard.double(forKey: "BBIWeightKey")
    @State private var currentPoundWeight: Double = UserDefaults.standard.double(forKey: "BBIWeightKey")
    
    @State var waistTickRange: [Float] = [0,20,40,60,80,100, 120]
    @State var poundWaistTickRange: [Float] = [0, 50, 100, 150, 200, 250,300]
    @State private var desiredWaistRange: (Double, Double) = (1, 6)
    @State private var currentWaistRange: (Double, Double) = (50, 120)
    @State private var currentpoundWaistRange: (Double, Double) = (20, 50)
    
    @State private var currentWaist: Double = UserDefaults.standard.double(forKey: "BBIWaistKey")
    @State private var currentPoundWaist: Double = UserDefaults.standard.double(forKey: "BBIWaistKey")

    
    var body: some View {
        VStack (alignment: .leading, spacing: 25) {
            
            VStack (alignment: .leading, spacing: 10) {
                
                Button(action: {
                       self.facebookManager.isUserAuthenticated = .signedIn
                }) {
                
                    Image(systemName: "chevron.left")
                    .foregroundColor(Color("primary"))
                }.frame(width: 40, height: 40)
                
//                Image(systemName: "chevron.left")
//                    .resizable()
//                    .foregroundColor(Color("primary"))
//                    .padding()
//                    .frame(width: 45, height: 50)
                    
                            
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
                    Text("My current weight is")
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
                    Text("My last waist is")
                        .foregroundColor(Color("primary"))
                        .font(.body)
                    
                    Spacer()
                    
                    Text("65 cm")
                        .foregroundColor(Color("primary"))
                        .font(.body)
                }
                
                HStack (spacing: 5) {
                    Text("My current waist is")
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
                let userId = UserDefaults.standard.integer(forKey: "userId")
                let weight = self.userGoal.switchMetric ? self.currentWeight : self.currentPoundWeight
                
                let waist = self.userGoal.switchMetric ? self.currentWaist : self.currentPoundWaist
                
                let strWeight = String(format: "%.0f", weight)
                let strWaist = String(format: "%.0f", waist)
                
                print("temp weight ====== ", strWeight)
                
                BBIModelEndpoint.sharedService.updateUserWeight(userId: userId, weight: strWeight, measureType: "self") { result in
                    
                    switch result {
                    case .success(let response):
                        print("Update weight success ====== ", response)
                        UserDefaults.standard.set(Int(strWeight), forKey: "BBIWeightKey")
                        
                        BBIModelEndpoint.sharedService.updateUserWaist(userId: userId, waist: strWaist, measureType: "self") { result in
                            
                            switch result {
                            case .success(let response):
                                print("Update waist success ======= ", response)
                                UserDefaults.standard.set(Int(strWaist), forKey: "BBIWaistKey")
                                
                                print("Userdefaults weight ======== ", UserDefaults.standard.double(forKey: "BBIWeightKey"))
                                print("Userdefaults waist ======== ", UserDefaults.standard.double(forKey: "BBIWaistKey"))
                                
                                UserDefaults.standard.set(true, forKey: "showWellDonePop")
                                
                                self.facebookManager.isUserAuthenticated = .signedIn
                                
                            case .failure(let error):
                                print("Update waist failed ====== ", error)
                            }
                            
                        }
                    
                    case .failure(let error):
                        print("Update weight fail", error)
                    }
                }
                
            }, label: {
                    Text("Update")
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
