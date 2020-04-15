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
    @State var currentWeight: Float = 65
    @State var desiredWeight: Float = 50
    @EnvironmentObject var facebookManager: FacebookManager

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
                    .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color("primary"))
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, -30)
            
            Text("What's your \ngoal Parisa?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
                .padding(.bottom, 20)
            
            VStack {
                HStack {
                    Text("Current Weight")
                        .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                    .fontWeight(.bold)

                    
                    Spacer()
                    
                    Text("\(Int(currentWeight)) kg")
                        .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                    
                }
                SliderView(percentage: $currentWeight, hideTicker: false).frame( height: 20)
                .padding(.bottom, 40)
            }
            
            VStack {
                HStack {
                    Text("Desired Weight")
                        .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                    .fontWeight(.bold)

                    
                    Spacer()
                    
                    Text("\(Int(desiredWeight)) kg")
                        .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                    
                }
                SliderView(percentage: $desiredWeight, hideTicker: false).frame( height: 20)
                .padding(.bottom, 20)
            }
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
