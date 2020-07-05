//
//  UserGoalView.swift
//  BBI
//
//  Created by Sagar on 11/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine
import KeychainSwift


class UserGoal: ObservableObject, Identifiable {
    @Published var desiredWeight: Double = 3
    @Published var desiredPoundWeight: Double = 6
    @Published var currentWeightRange: (Double, Double) = (40, 120)
    @Published var desiredWeightRange: (Double, Double) = (0, 12)
    let WillChange = PassthroughSubject<Void, Never>()
    
 
    var currentWeight: Double = 65
    
    

    var switchMetric = UserDefaults.standard.bool(forKey: "Metrics") {
        didSet {
            if switchMetric {
                self.currentWeight = 65
            } else {
              
                self.currentWeight = 130
            }
            WillChange.send()
        }
    }
    
   // var switchMetric =


}


struct UserGoalView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var facebookManager: FacebookManager
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @ObservedObject var userGoal = UserGoal()
    @State var weightTickRange :[Float] = [0,20,40,60,80,100, 120]
    @State var  poundWeightTickRange: [Float] = [0, 50, 100, 150, 200, 250,300]
    @State var lostTickRange: [Float] = [0, 1, 2, 3, 4, 5, 6]
    @State var lostMetricTickRange: [Float] = [0, 2, 4, 6, 8, 10, 12]
    @State private var desiredWeightRange: (Double, Double) = (1, 6)
    @State private var currentWeightRange: (Double, Double) = (0, 120)
    @State private var currentpoundWeightRange: (Double, Double) = (0, 300)

    @State private var showingAlert = false
    @State private var showingConfirmation = false

    @State private var currentWeight: Double = 70
    @State private var currentPoundWeight: Double = 140

    let keychain = KeychainSwift()


    var bckButton: some View {
        Button(action: {
               self.presentationMode.wrappedValue.dismiss()
        }) {
        
        Image(systemName: "chevron.left")
            .foregroundColor(.black)
            }.frame(width: 40, height: 40)
    }
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            HStack (alignment: .center, spacing: 10) {
                
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("tertiary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("tertiary"))
               
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color("tertiary"))
                Circle()
                               .frame(width: 15, height: 15)
                               .foregroundColor(Color("primary"))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, -30).background(Color("bg-color"))

            
            Text("Whats your \ngoal \(self.userViewModel.getFirstName(fullName: (userViewModel.userObect?.name ?? keychain.get("nameFromApple")) ?? ""))?")
//                .font(.largeTitle)
//                .fontWeight(.bold)
                .lineLimit(2)
                .padding(.bottom, 20)
                .modifier(CustomHeaderFontModifier(size: 35))
            
            VStack {
                HStack {
                    Text("My weight is")
                    .modifier(CustomBoldBodyFontModifier(size: 20))
                    .foregroundColor(Color("secondary"))



                    
                    Spacer()
                    
                    
                    
                   
                    Text("\(Int(userGoal.switchMetric ? self.currentWeight : self.currentPoundWeight)) \(userGoal.switchMetric ? "Kg" : "lb")")                        .foregroundColor(Color("secondary"))

                    
                }
                SliderView(percentage: userGoal.switchMetric ? self.$currentWeight : self.$currentPoundWeight, hideTicker: false, range: self.userGoal.switchMetric ? self.currentWeightRange: currentpoundWeightRange, rangleLabel:(self.userGoal.switchMetric ?  self.$weightTickRange : self.$poundWeightTickRange) ).frame( height: 20)
                .padding(.bottom, 40)
            }
            
            VStack {
                HStack {
                    Text("I want to lose ")
                        .foregroundColor(Color("secondary"))
                        .modifier(CustomBoldBodyFontModifier(size: 20))

//                    .fontWeight(.bold)

                    Button(action: {
                        self.showingAlert = true

                        
                    }) {
                        Image(systemName:"info.circle").foregroundColor(Color("secondary"))
                    }        .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Health Information"), message: Text("Based on suggested research, \(self.userGoal.switchMetric ? "6Kg" : "12 lb" ) weightloss in 6 weeks is most healthy."), dismissButton: .default(Text("Ok")))
                    }
                    
                    Spacer()
                    
                    
                   // Text("\(switchMetric ? changeMetrics(metricType: .metric, unit: .weight, value: Int(desiredWeight)) : changeMetrics(metricType: .imperial, unit: .weight, value: Int(desiredWeight))) \(switchMetric ? "Kg" : "Pound")")
                    Text("\(Int(self.userGoal.switchMetric ? userGoal.desiredWeight : userGoal.desiredPoundWeight)) \(userGoal.switchMetric ? "Kg" : "lb")")                        .foregroundColor(Color("secondary"))
                    
                }
                
                SliderView(percentage:self.userGoal.switchMetric ? $userGoal.desiredWeight : $userGoal.desiredPoundWeight, hideTicker: false, range: self.userGoal.switchMetric ? (0,6) : (0, 12),rangleLabel: self.userGoal.switchMetric ?   self.$lostTickRange : self.$lostMetricTickRange).frame( height: 20)
                .padding(.bottom, 20)
                //range: (currentWeight-(currentWeight * 0.10),
            }
            
           // MetricsConversionView(switchMetric: $userGoal.switchMetric)

            Spacer()
            
            HStack(alignment: .center) {
                Button(action: {
                   // self.facebookManager.isUserAuthenticated = .cameraOnboard
                    //DashboardView()
                    self.showingConfirmation = true
                    
                    
                }, label: {
                    Spacer()
                        Text("I am ready!")
                            .padding()
                            .foregroundColor(.white)
                            .modifier(CustomBoldBodyFontModifier(size: 20))

                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .background(Color("primary"))
                    .cornerRadius(30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                .shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
                    .alert(isPresented: $showingConfirmation) {
                        Alert(title: Text("Confirmation "), message: Text("Please confirm your details before continuing to the next step."), primaryButton: .default(Text("Confirm")) {
                            //Save The value
                            UserDefaults.standard.set(self.userGoal.currentWeight, forKey: "BBIWeightKey")
                            UserDefaults.standard.set(self.userGoal.desiredWeight, forKey: "BBIUserGoalKey")
                            
                            
                            self.saveDataToServer()
                                self.facebookManager.isUserAuthenticated = .cameratutorial
                        }, secondaryButton: .cancel())
                }

            }.frame(minWidth: 0, maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: bckButton.padding(.leading, -5))
        .background(Color("bg-color"))

    }
    
    func saveDataToServer() {
        let keychain = KeychainSwift()
        let firstName = keychain.get("BBIFirstNameKey")
        let lastName = keychain.get("BBILastNameKey")
        let emailFromApple = keychain.get("BBIEmailKey")
        let emailFromFacebook = keychain.get("emailFromApple")
        let fullName = keychain.get("BBIFullNameKey")
        
        let gender = UserDefaults.standard.string(forKey: "BBIGenderKey")
        let age = UserDefaults.standard.integer(forKey: "BBIAgeKey")
        let height = UserDefaults.standard.double(forKey: "BBIHeightKey")
        let activityType = UserDefaults.standard.integer(forKey: "BBIActivityKey")
        let bodyType = UserDefaults.standard.integer(forKey: "BBIBodyTypeKey")
        let weight = UserDefaults.standard.double(forKey: "BBIWeightKey")
        let userGoal = UserDefaults.standard.double(forKey: "BBIUserGoalKey")
        
        BBIModelEndpoint.sharedService.createNewUsername(username: (emailFromApple ?? emailFromFacebook) ?? "defaultUserName" , email: (emailFromApple ?? emailFromFacebook) ?? "test@BBI.com", fullName: fullName ?? "", gender: gender ?? "", height: height , weight: weight , waistSize: 0, bodyTypeId: bodyType , activityLevelId: activityType , firstName: firstName ?? "N/A", lastName: lastName ?? "N/A", BMR: "test", GoalWeightChange: 1, GoalWeight: userGoal, GoalType: 123, Password: "")
    }
}

struct UserGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UserGoalView()
    }
}
