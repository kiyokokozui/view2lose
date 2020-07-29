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
    
    var body: some View {

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
                    
                    Spacer()
                    
                    VStack (alignment: .leading) {
                        Text("Taking regular body measurements helps keep track of your health and measure body change progress through time!")
                            .font(.body)
                            .foregroundColor(Color(.lightGray))
                            .padding(15)
                            .lineLimit(nil)
                        
                        Text("The steps are:")
                        .font(.body)
                        .foregroundColor(Color(.lightGray))
                        .padding()

                        HStack {
                            Image(systemName: "chevron.down")
                            
                            Text("Updating Current Weight")
                            .font(.body)
                        }.padding(.leading)
                        
                        HStack {
                            Image(systemName: "chevron.down")
                            
                            Text("Taking New Photos")
                            .font(.body)
                        }.padding()
                        
                        HStack {
                            Image(systemName: "chevron.down")
                            
                            Text("Updating Waist Measurement")
                            .font(.body)
                        }.padding(.leading)
                    }
                    
                    Button(action: {
                        self.showOverlay = false
                    }, label: {
                        Text("Start").modifier(CustomBoldBodyFontModifier(size: 20))
                    }).padding(.top, 20).padding(.bottom, 20).foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("primary"))
                        .cornerRadius(30)
                        .padding().shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
                }
            }.background(Color(.white))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 500)
            .cornerRadius(25)
        }
    }
}

struct Update_Previews: PreviewProvider {
    static var previews: some View {
        Update()
    }
}
