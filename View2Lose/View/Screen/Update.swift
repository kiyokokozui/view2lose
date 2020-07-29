//
//  Update.swift
//  View2Lose
//
//  Created by Jason on 1/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct AlertMessage: View {
    var body: some View {
        VStack {
            Text("Update Measurement")
                .bold()
                .font(.title)
            
            Spacer()
            
            Text("Paragraph is here")
                .font(.body)
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Text("Start").modifier(CustomBoldBodyFontModifier(size: 20))
            }).padding(.top, 20).padding(.bottom, 20).foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("primary"))
                .cornerRadius(30)
                .padding().shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
        }
        
    }
}

struct Update: View {
    @State var showOverlay = true
    @EnvironmentObject var facebookManager: FacebookManager
    
    var body: some View {
//        NavigationView {
            ZStack (alignment: .bottom) {
                Rectangle()
                    .fill(Color(.gray))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                VStack {
                    if self.showOverlay {
                        HStack {
                            Button(action: {
                                print("Tapped")
                            }, label: {
                                Image(systemName: "chevron.down")
                                    .frame(alignment: .trailing)
                                    .foregroundColor(Color(.black))
                            })
                                .foregroundColor(Color(.black))
                        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            .padding(15)
                        
                        Text("Update Measurement")
                            .bold()
                            .font(.title)
                        
                        VStack (alignment: .leading) {
                            Text("You can measure and update the waist and weight measurements manually or")
                                .font(.body)
                                .foregroundColor(Color(.lightGray))
                                .padding(15)
                                .lineLimit(nil)
                            
                            Text("You can automatically update your waist measurement by taking photos")
                            .font(.body)
                            .foregroundColor(Color(.lightGray))
                            .padding()

                        }.padding()
                        
                        VStack (alignment: .center) {
                            
//                                NavigationLink(destination: UpdateMeasurement()) {
                                    Button(action: {
                                        print("Update manually")
                                        self.facebookManager.isUserAuthenticated = .updateMeasurement
                                    }, label: {
                                        Text("Update manually").modifier(CustomBoldBodyFontModifier(size: 20))
                                    }).padding(.top, 20).padding(.bottom, 20).foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(Color("primary"))
                                        .cornerRadius(30)
                                        .padding().shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
//                            }
                            
                            Button(action: {
                                self.showOverlay = false
                            }, label: {
                                Text("Update with taking photo").modifier(CustomBoldBodyFontModifier(size: 20))
                                .foregroundColor(Color("primary"))
                            }).padding(.top, 20).padding(.bottom, 20).foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(Color(.white))
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color("primary"), lineWidth: 2))
                                .cornerRadius(30)
                                .padding().shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
                        }.padding()
                        Spacer()
                    }
                }.background(Color(.white))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 500)
                .cornerRadius(30)
                .offset(x: 0, y: 20)
            }
//        }.navigationBarHidden(true)
//        .navigationBarTitle("", displayMode: .inline)
//        .edgesIgnoringSafeArea([.top])
//        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct Update_Previews: PreviewProvider {
    static var previews: some View {
        Update()
    }
}
