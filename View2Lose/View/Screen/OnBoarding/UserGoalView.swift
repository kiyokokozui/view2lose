//
//  UserGoalView.swift
//  BBI
//
//  Created by Sagar on 11/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct UserGoalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var currentWeight: Double = 65
    @State var desiredWeight: Double = 50
    @EnvironmentObject var facebookManager: FacebookManager
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    
    @State private var switchMetric = true

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
            
            Text("What's your \ngoal \(self.userViewModel.getFirstName(fullName: userViewModel.userObect?.name ?? ""))?")
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
                    
                    
                    Text("\(switchMetric ? changeMetrics(metricType: .metric, unit: .weight, value: Int(currentWeight)) : changeMetrics(metricType: .imperial, unit: .weight, value: Int(currentWeight))) \(switchMetric ? "Kg" : "Pound")")
                    .foregroundColor(Color("secondary"))
                    
                }
                SliderView(percentage: $currentWeight, hideTicker: false, range: (40, 120)).frame( height: 20)
                .padding(.bottom, 40)
            }
            
            VStack {
                HStack {
                    Text("Desired Weight")
                        .foregroundColor(Color("secondary"))
                    .fontWeight(.bold)

                    
                    Spacer()
                    
                    
                    Text("\(switchMetric ? changeMetrics(metricType: .metric, unit: .weight, value: Int(desiredWeight)) : changeMetrics(metricType: .imperial, unit: .weight, value: Int(desiredWeight))) \(switchMetric ? "Kg" : "Pound")")
                    .foregroundColor(Color("secondary"))

                    
                }
                
                SliderView(percentage: $desiredWeight, hideTicker: false, range: (currentWeight - (currentWeight * 0.1), currentWeight))
                .padding(.bottom, 20)
                //range: (currentWeight-(currentWeight * 0.10),
            }
            
            MetricsConversionView(switchMetric: $switchMetric)

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
