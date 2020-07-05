//
//  ContentView.swift
//  View2Lose
//
//  Created by Sagar on 9/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine
import KeychainSwift

class UserBasicInfo: ObservableObject, Identifiable {
    @Published var age: Double = 0
    @Published var percentage: Double = 40
    @Published var height: Double = 180
    @Published var heightRange : (Double, Double) = (140,200)
      var  heightTickRange: [Float] = [140, 150, 160, 170, 180, 190, 200]
     var  heightTickMetricRange:[Float] = [4,4.5, 5, 5.5, 6, 6.5, 7]
    let WillChange = PassthroughSubject<Void, Never>()

    @Published var changeMetric = true
    var switchMetric = 0 {
        didSet {
            if switchMetric == 0 {
                self.heightRange = (140, 200)
                self.changeMetric = true
                self.height = changeMetrics(metricType: .metric, unit: .height, value: height)
                UserDefaults.standard.set(true, forKey: "Metrics")
                self.heightTickRange = [140, 150, 160, 170, 180, 190, 200]

            } else if switchMetric == 1 {
                self.heightRange = (4, 7)
                self.changeMetric = false
                self.height = changeMetrics(metricType: .imperial, unit: .height, value: height)
                UserDefaults.standard.set(false, forKey: "Metrics")
                self.heightTickRange = [4,4.5, 5, 5.5, 6, 6.5, 7]
            }
            WillChange.send()
        }
    }
    @Published var isFemale = false
    @Published var isMale = false
    

    
}



struct ContentView: View {
    
    @ObservedObject var userbasicInfo = UserBasicInfo()
    @ObservedObject var userViewModel: UserViewModel
    @State var ageTickRange :[Float] = [10,20,30,40,50,60,70]
    @State var  heightTickRange: [Float] = [140, 150, 160, 170, 180, 190, 200]
      @State var  heightTickMetricRange:[Float] = [4,4.5, 5, 5.5, 6, 6.5, 7]
    
    @EnvironmentObject var userInfo : UserBasicInfo
    
    let keychain = KeychainSwift()
    var metricsName = ["Metric", "U.S"]
   // @State private var switchMetric1 = 1
    @State var selection: Int? = nil


    init(viewModel: UserViewModel)
    {
        self.userViewModel = viewModel
        UISwitch.appearance().onTintColor = #colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1)
        UserDefaults.standard.set(true, forKey: "Metrics")
        
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
               UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"primary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .selected)
               UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"secondary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .normal)
        
        let keychain = KeychainSwift()
        keychain.set(self.userViewModel.getFirstName(fullName: (userViewModel.userObect?.name ?? keychain.get("nameFromApple")) ?? "") , forKey: "BBIFirstNameKey")
        keychain.set(self.userViewModel.getLastName(fullName: (userViewModel.userObect?.name ?? keychain.get("nameFromApple")) ?? "") , forKey: "BBILastNameKey")
        keychain.set(self.userViewModel.userObect?.email ?? keychain.get("emailFromApple") ?? "", forKey: "BBIEmailKey")
        keychain.set(self.userViewModel.userObect?.name ??  keychain.get("nameFromApple") ?? "", forKey: "BBIFullNameKey")

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
                            .foregroundColor(Color("tertiary"))
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color("tertiary"))
                        Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color("tertiary"))
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.top, -30).background(Color("bg-color"))

                    
                }        .background(Color("bg-color"))

                Text("Lets get to \nknow you \(self.userViewModel.getFirstName(fullName: (userViewModel.userObect?.name ?? keychain.get("nameFromApple")) ?? "") )!")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
                    
                    .lineLimit(2)
                    .modifier(CustomHeaderFontModifier(size: 35))

                
                Text("My gender is")
                    .foregroundColor(Color("secondary"))
                    .fontWeight(.bold)
                .modifier(CustomBodyFontModifier(size: 16))

                
                
                HStack (alignment: .center, spacing: 25) {
                    
                    GenderButton(isSelected: $userbasicInfo.isFemale, type: "👩🏻")
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 30)
                
                VStack {
                    HStack {
                        Text("My age is")
                            .foregroundColor(Color("secondary"))
                            .fontWeight(.bold)
                        .modifier(CustomBoldBodyFontModifier(size: 16))

                        
                        Spacer()
                        
                        Text("\(Int(userbasicInfo.percentage)) years")
                            .foregroundColor(Color("secondary"))
                        .modifier(CustomBodyFontModifier(size: 16))

                        
                    }
                    SliderView(percentage: $userbasicInfo.percentage, hideTicker: false, range: (10, 70),rangleLabel: $ageTickRange).frame( height: 20)
                        .padding(.bottom, 20)
    
                    

                }.padding(.bottom, 10)
                
                VStack {
                    HStack {
                        Text("My height is")
                            .foregroundColor(Color("secondary"))
                        .fontWeight(.bold)
                        .modifier(CustomBoldBodyFontModifier(size: 16))


                        Spacer()
                        
                       // Text("\(switchMetric ? changeMetrics(metricType: .metric, unit: .height, value: height) : changeMetrics(metricType: .imperial, unit: .height, value: height)) \(switchMetric ? "cm" : "inches")"))
                        Text(" \(userbasicInfo.height, specifier: "%.1f") \(userbasicInfo.changeMetric ? "cm" : "feet")").foregroundColor(Color("secondary"))
                    }
                    SliderViewBinding(percentage:  $userbasicInfo.height, hideTicker: false, range:  $userbasicInfo.heightRange , rangleLabel: userbasicInfo.changeMetric ? self.$heightTickRange : self.$heightTickMetricRange, isUSMetric: $userbasicInfo.changeMetric).environmentObject(self.userbasicInfo).frame( height: 15).frame( height: 20).padding(.bottom, 20)
                   // print(self.userbasicInfo.switchMetric)
//                    if order.switchMetric {
//                       SliderViewBinding(percentage:  $order.height, hideTicker: false, range:  $order.heightRange , rangleLabel:   self.heightTickRange ).frame( height: 15).frame( height: 20)
//                                                  .padding(.bottom, 20)
//                    } else {
//    SliderViewBinding(percentage:  $order.height, hideTicker: false, range:  $order.heightRange , rangleLabel:   self.heightTickMetricRange ).frame( height: 15).frame( height: 20)
//    .padding(.bottom, 20)                    }
                    
                    //SliderTick()
                }
                HStack {
                    Spacer()
                   // MetricsConversionView()
                    Picker("", selection: self.$userbasicInfo.switchMetric) {
                        ForEach(0..<metricsName.count) { index in
                            Text(self.metricsName[index]).tag(index)                     .modifier(CustomBodyFontModifier(size: 17))

                        }
                        
                        
                        }.pickerStyle(SegmentedPickerStyle()).background(Color(#colorLiteral(red: 0.9475272298, green: 0.9246528745, blue: 1, alpha: 1)))
                    .frame(width: 175)
                    Spacer()

                }.padding(.vertical, 20)
            
                
                
                Spacer()
                
                HStack(alignment: .center) {
                    
                        Spacer()
                        NavigationLink(destination: ActivityView(), tag: 1, selection: $selection) {
                            Button(action: {
                                self.selection = 1
                                print("Pressed")
                               // let keychain = KeychainSwift()
                                if self.userbasicInfo.isMale {
                                    //keychain.set("M", forKey: "BBIGenderKey")
                                    UserDefaults.standard.set("M", forKey: "BBIGenderKey")

                                } else if self.userbasicInfo.isFemale {
                                  // keychain.set("F", forKey: "BBIGenderKey")
                                    UserDefaults.standard.set("F", forKey: "BBIGenderKey")

                                }
                                
                                //keychain.set("\(self.userInfo.percentage)", forKey: "BBIAgeKey")
                                UserDefaults.standard.set(self.userbasicInfo.percentage, forKey: "BBIAgeKey")
                                UserDefaults.standard.set(self.userbasicInfo.height, forKey: "BBIHeightKey")

                                //keychain.set(self.userInfo.percentage, forKey: "BBIHeightKey")

                            }) {
                                Text("Continue")
                                .padding()
                                .foregroundColor(.white)
                                .modifier(CustomBoldBodyFontModifier(size: 20))

                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                        } .background(Color("primary"))

                            .cornerRadius(30)
                        .padding(.bottom, 20)
                    .shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 1, y: 2)
                        
                
                        

                }.frame(minWidth: 0, maxWidth: .infinity)
            }.padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
                .navigationBarTitle("", displayMode: .inline)
            .background(Color("bg-color"))
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
                .frame(width: 153, height: 124)
                .background(Color.white)
                .cornerRadius(10)
                    
                .shadow(color: self.selected == i ? Color("primary") : Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)), radius: 5, x: 1, y: 5)
                .shadow(color: self.selected == i ? Color("primary") : Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)), radius: 2, x: 1, y: -1)
                
                
                
            })
        }
        
        
    }
}

