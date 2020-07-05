//
//  CameraTutorialSecondView.swift
//  View2Lose
//
//  Created by purich purisinsits on 10/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct CameraTutorialSecondView: View {
    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            HStack {
                // CIRCLE TAB
                HStack (alignment: .center, spacing: 10) {
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color("tertiary"))
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color("primary"))
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color("tertiary"))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.top, -30)
            }
            //DESCRIPTION
            //HEADER
            Text("Take Your Photos")
                .modifier(CustomHeaderFontModifier(size: 35))
            
            Spacer()
            
            //IMAGE
            ZStack(alignment: .center){
                Image("tutorial screen 2 body image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(60)
                //GREEN RECTANGLE
                Rectangle()
                    .stroke(Color.green, lineWidth: 5)
                
                VStack(){
                    VStack{
                        HStack(alignment: .top){
                            Spacer()
                            ZStack{
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("primary"))
                                Text("1")
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 2)
                            
                            Text("Keep your phone vertically to see the green border")
                                .foregroundColor(Color("secondary"))
                                .frame(minWidth: 0, maxWidth: 130)
                        }
                        
                    }

                    //Spacer()
                    
                    HStack(alignment: .top){
                        ZStack{
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("primary"))
                            Text("2")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 2)
                        
                        Text("Keep your body inside the outline")
                            .foregroundColor(Color("secondary"))
                            .frame(minWidth: 0, maxWidth: 100)
                        Spacer()
                        
                        //arrow under number 1
                        Image("ArrowRight")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("secondary"))
                    }

                    //arrow number 2
                    HStack(){
                        Image("ArrowRight")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("secondary"))
                            .padding(.leading, 60)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    //arrow number 3
                    HStack(){
                        Spacer()
                        
                        Image("ArrowUp")
                            .renderingMode(.template)
                            .resizable()
                            //.aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 60)
                            .foregroundColor(Color("secondary"))
                            .padding(.trailing, 30)
                    }

                    HStack{
                        ZStack{
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("primary"))
                            Text("3")
                                .foregroundColor(.white)
                        }
                        Text("Stand in front of a plain background")
                            .foregroundColor(Color("secondary"))
                    }
                }
                .padding(10)
            }
            Spacer()
            
            
            
            //BUTTON
            HStack{
                NavigationLink(destination: CameraTutorialThirdView()){
                    Text("Continue")
                        .padding()
                        .foregroundColor(.white)
                        .modifier(CustomBoldBodyFontModifier(size: 20))

                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .background(Color("primary"))
                .cornerRadius(30)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.bottom, 20)
        }//VStack END
        .padding(.horizontal, 20)

    }
}

struct CameraTutorialSecondView_Previews: PreviewProvider {
    static var previews: some View {
        CameraTutorialSecondView()
    }
}
