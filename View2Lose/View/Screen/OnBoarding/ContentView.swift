//
//  ContentView.swift
//  View2Lose
//
//  Created by Sagar on 9/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

class Order: ObservableObject, Identifiable {
    @Published var age: Double = 0
    @Published var percentage: Double = 40
    @Published var height: Double = 180
    @Published var heightRange : (Double, Double) = (150,200)
    let WillChange = PassthroughSubject<Void, Never>()

    
    var switchMetric = true {
        didSet {
            if switchMetric {
                self.heightRange = (150, 200)
                self.height = changeMetrics(metricType: .metric, unit: .height, value: height)
            } else {
                self.heightRange = (59.05, 78.74)
                self.height = changeMetrics(metricType: .imperial, unit: .height, value: height)

            }
            WillChange.send()
        }
    }
    @Published var isFemale = false
    @Published var isMale = false
    

    
}



struct ContentView: View {
    
    @ObservedObject var order = Order()
    @ObservedObject var userViewModel: UserViewModel
    let ageTickRange :[Int] = [10,20,30,40,50,60]
     let heightTickRange: [Int] = [150, 160, 170, 180, 190, 200]

    init(viewModel: UserViewModel)
    {
        self.userViewModel = viewModel
        UISwitch.appearance().onTintColor = #colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1)
        
        BBIModelEndpoint.sharedService.createNewUsername(username: "sagar1212", email: "test@gmail.com", fullName: "Sagar Chhetri", gender: "M", height: 157, weight: 65, waistSize: 33, bodyTypeId: 1, activityLevelId: 12, firstName: "Sagar", lastName: "Chhetri", BMR: "test", GoalWeightChange: 1, GoalWeight: 2, GoalType: 123, Password: "Password")
    }
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var bckButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
/*
     
     
     var changeToFrontCamera = true {
     didSet {
         if changeToFrontCamera {
             if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                     for: .video, position: .back) {
                 currentCamera = device
             } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                            for: .video, position: .back) {
                 currentCamera = device
             } else {
                 fatalError("Missing expected back camera device.")
             }
         } else {
             if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                 currentCamera = frontCameraDevice
             }

         }
     }
     */
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 10) {
                HStack {
                    
                    HStack (alignment: .center, spacing: 10) {
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color("primary"))
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color("secondary"))
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color("secondary"))
                        Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color("secondary"))
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.top, -30)
                    
                }
                Text("Lets get to \nknow you \(self.userViewModel.getFirstName(fullName: (userViewModel.userObect?.name ?? UserDefaults.standard.string(forKey: "nameFromApple")) ?? "") )!")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
                    .lineLimit(2)
                    .modifier(CustomHeaderFontModifier(size: 35))

                
                Text("My gender is")
                    .foregroundColor(Color("secondary"))
                .modifier(CustomBodyFontModifier(size: 16))

                
                
                HStack (alignment: .center, spacing: 20) {
                    
                    GenderButton(isSelected: $order.isFemale, type: "👩🏻")
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 30)
                
                VStack {
                    HStack {
                        Text("Age")
                            .foregroundColor(Color("secondary"))
                            .fontWeight(.bold)
                        .modifier(CustomBoldBodyFontModifier(size: 16))

                        
                        Spacer()
                        
                        Text("\(Int(order.percentage)) years")
                            .foregroundColor(Color("secondary"))
                        .modifier(CustomBodyFontModifier(size: 16))

                        
                    }
                    SliderView(percentage: $order.percentage, hideTicker: false, range: (10, 60),rangleLabel: ageTickRange).frame( height: 20)
                        .padding(.bottom, 20)
    
                    

                }.padding(.bottom, 10)
                
                VStack {
                    HStack {
                        Text("Height")
                            .foregroundColor(Color("secondary"))
                        .fontWeight(.bold)
                        .modifier(CustomBoldBodyFontModifier(size: 16))


                        Spacer()
                        
                       // Text("\(switchMetric ? changeMetrics(metricType: .metric, unit: .height, value: height) : changeMetrics(metricType: .imperial, unit: .height, value: height)) \(switchMetric ? "cm" : "inches")"))
                        Text(" \(Int(order.height)) \(order.switchMetric ? "cm" : "inches")").foregroundColor(Color("secondary"))
                    }
                    SliderViewBinding(percentage:  $order.height, hideTicker: false, range: $order.heightRange, rangleLabel: self.heightTickRange).frame( height: 15).frame( height: 20)
                    .padding(.bottom, 20)
                    //SliderTick()
                }
                MetricsConversionView(switchMetric: $order.switchMetric)
                
                    
                
                
                Spacer()
                
                HStack(alignment: .center) {
                    
                        Spacer()
                        NavigationLink(destination: ActivityView()) {
                            Text("Continue")
                                .padding()
                                .foregroundColor(.white)
                                .modifier(CustomBodyFontModifier(size: 16))

                                .frame(maxWidth: .infinity, alignment: .center)
                        }.background(Color("primary"))
                            .cornerRadius(30)
                        .padding(.bottom, 10)
                        
                
                        

                }.frame(minWidth: 0, maxWidth: .infinity)
            }.padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
                .navigationBarTitle("", displayMode: .inline)
               // .navigationBarItems(leading: bckButton.padding(.leading, 5))
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: UserViewModel())
    }
}
var genderData = ["👩🏻", "👦🏻"]

struct GenderButton: View {
    
    @State var selected = ""
    @State var show = false
    @Binding var isSelected: Bool
    var type: String
    var body: some View {
        ForEach(genderData, id: \.self) { i in
            Button(action: {
                self.selected = i
            }, label: {
                HStack (alignment: .center) {
                    Text(i)
                        .font(.system(size: 49))
                }
                .frame(width: 120, height: 120)
                .background(Color.white)
                .cornerRadius(10)
                    
                .shadow(color: self.selected == i ? Color("primary") : Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)), radius: 5, x: 1, y: 5)
                .shadow(color: self.selected == i ? Color("primary") : Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)), radius: 2, x: 1, y: -1)
                
                
                
            })
        }
        
        
    }
}

