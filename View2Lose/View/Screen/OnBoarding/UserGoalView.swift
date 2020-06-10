//
//  UserGoalView.swift
//  BBI
//
//  Created by Sagar on 11/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

class UserGoal: ObservableObject, Identifiable {
    @Published var desiredWeight: Double = 3
    @Published var currentWeightRange: (Double, Double) = (40, 120)
    @Published var desiredWeightRange: (Double, Double) = (0, 12)
    let WillChange = PassthroughSubject<Void, Never>()
    
 
    var currentWeight: Double = 65
    
    

    var switchMetric = true {
        didSet {
            if switchMetric {
                self.currentWeightRange = (22.04, 198.416)
                self.currentWeight = changeMetrics(metricType: .metric, unit: .weight, value: currentWeight)
            } else {
                self.currentWeightRange = (10, 90)
                self.currentWeight = changeMetrics(metricType: .imperial, unit: .weight, value: currentWeight)

            }
            WillChange.send()
        }
    }

}


struct UserGoalView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var facebookManager: FacebookManager
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @ObservedObject var userGoal = UserGoal()
    let weightTickRange :[Int] = [40,60,80,100,110,120]
        let lostTickRange: [Int] = [0, 2, 5, 7, 9, 12]
    @State private var desiredWeightRange: (Double, Double) = (0, 12)
    @State private var currentWeightRange: (Double, Double) = (40, 120)
    @State private var showingAlert = false
    @State private var currentWeight: Double = 65


    var bckButton: some View {
        Button(action: {
               self.presentationMode.wrappedValue.dismiss()
        }) {
        
        Image(systemName: "chevron.left")
            .foregroundColor(.black)
        }
    }
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            HStack (alignment: .center, spacing: 10) {
                
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("secondary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("secondary"))
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color("primary"))
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color("secondary"))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, -30)
            
            Text("What's your \ngoal \(self.userViewModel.getFirstName(fullName: (userViewModel.userObect?.name ?? UserDefaults.standard.string(forKey: "nameFromApple")) ?? ""))?")
//                .font(.largeTitle)
//                .fontWeight(.bold)
                .lineLimit(2)
                .padding(.bottom, 20)
                .modifier(CustomHeaderFontModifier(size: 35))
            
            VStack {
                HStack {
                    Text("Current Weight")
                        .foregroundColor(Color("secondary"))
                    .fontWeight(.bold)

                    
                    Spacer()
                    
                    
                    
                   
                    Text("\(Int(userGoal.currentWeight)) \(userGoal.switchMetric ? "Kg" : "Pound")")                        .foregroundColor(Color("secondary"))

                    
                }
                SliderView(percentage: self.$currentWeight, hideTicker: false, range: self.currentWeightRange, rangleLabel:self.weightTickRange ).frame( height: 20)
                .padding(.bottom, 40)
            }
            
            VStack {
                HStack {
                    Text("I want to lose ")
                        .foregroundColor(Color("secondary"))
                    .fontWeight(.bold)

                    Button(action: {
                        self.showingAlert = true

                        
                    }) {
                        Image(systemName:"info.circle").foregroundColor(Color("secondary"))
                    }        .alert(isPresented: $showingAlert) {
Alert(title: Text("Health Information"), message: Text("Based on suggested research, 12kg weightloss in 6 weeks is most healthy."), dismissButton: .default(Text("Ok")))
                    }
                    
                    Spacer()
                    
                    
                   // Text("\(switchMetric ? changeMetrics(metricType: .metric, unit: .weight, value: Int(desiredWeight)) : changeMetrics(metricType: .imperial, unit: .weight, value: Int(desiredWeight))) \(switchMetric ? "Kg" : "Pound")")
                    Text("\(Int(userGoal.desiredWeight)) \(userGoal.switchMetric ? "Kg" : "Pound")")                        .foregroundColor(Color("secondary"))
                    
                }
                
                SliderView(percentage: $userGoal.desiredWeight, hideTicker: false, range: (0,12),rangleLabel: self.lostTickRange).frame( height: 20)
                .padding(.bottom, 20)
                //range: (currentWeight-(currentWeight * 0.10),
            }
            
           // MetricsConversionView(switchMetric: $userGoal.switchMetric)

            Spacer()
            
            HStack(alignment: .center) {
                Spacer()
                  NavigationLink(destination: BodyTypeView()) {
                                          Text("Continue")
                                              .padding()
                                              .foregroundColor(.white)
                                              
                                              .frame(maxWidth: .infinity, alignment: .center)
                                      }.background(Color("primary"))
                                          .cornerRadius(30)
                                      .padding(.bottom, 10)
            }.frame(minWidth: 0, maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: bckButton.padding(.leading, 5))
    }
}

struct UserGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UserGoalView()
    }
}
