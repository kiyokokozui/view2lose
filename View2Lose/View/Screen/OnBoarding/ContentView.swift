//
//  ContentView.swift
//  View2Lose
//
//  Created by Sagar on 9/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var age: Double = 0
    @State var percentage: Float = 50
    @State var height: Float = 50
    @State private var switchMetric = true
    @State var isFemale = false
    @State var isMale = false
    
    init()
    {
        UISwitch.appearance().onTintColor = #colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1)
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
                            .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                        Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.top, -30)
                    
                }
                Text("Lets get to \nknow you Parisa!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Text("Pick your genger")
                    .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                
                
                HStack (alignment: .center, spacing: 20) {
                    
                    GenderButton(isSelected: $isFemale, type: "👩🏻")
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 30)
                
                VStack {
                    HStack {
                        Text("Age")
                            .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("\(Int(percentage)) years")
                            .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                        
                    }
                    SliderView(percentage: $percentage, hideTicker: false).frame( height: 20)
                        .padding(.bottom, 20)
    
                    

                }
                
                VStack {
                    HStack {
                        Text("Height")
                            .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                        .fontWeight(.bold)

                        Spacer()
                        
                        Text("\(Int(height)) cm")
                            .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                        
                    }
                    SliderView(percentage: $height, hideTicker: false).frame( height: 15).frame( height: 20)
                    .padding(.bottom, 20)
                    //SliderTick()
                }
                HStack (alignment: .center) {
                    Text ("Imperial").font(.system(size: 14))
                        .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                    Toggle(isOn: $switchMetric) {
                        Text("")
                        
                    }
                    .labelsHidden()
                    .padding()
                    Text ("Metric").font(.system(size: 14))
                        .foregroundColor(Color.init(#colorLiteral(red: 0.8044032454, green: 0.8044223189, blue: 0.8044120669, alpha: 1)))
                    
                    
                    
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                
                Spacer()
                
                HStack(alignment: .center) {
                    
                        Spacer()
                        NavigationLink(destination: ActivityView()) {
                            Text("Continue")
                                .padding()
                                .foregroundColor(.white)
                                
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
        ContentView()
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

