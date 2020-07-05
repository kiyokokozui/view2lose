//
//  CameraTutorialThirdView.swift
//  View2Lose
//
//  Created by purich purisinsits on 10/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import SwiftyGif

struct CameraTutorialThirdView: View {
    
    //var svgName = "SVGTutorial"
    @State var scale: CGFloat = 1
    @State var play = true
    @EnvironmentObject var facebookManager: FacebookManager
    
    var body: some View {
        VStack (alignment: .center, spacing: 0) {
            HStack {
                // CIRCLE TAB
                HStack (alignment: .center, spacing: 10) {
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
                .padding(.top, -30)
            }
            //DESCRIPTION
            //HEADER
            Text("Selecting Body Points")
                .modifier(CustomHeaderFontModifier(size: 35))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal, 10)
            
            Spacer()
            
            ZStack{
                GifView(gifName: "ip8plus-tutorial", play: $play)
                    .clipped()
                
                VStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 10)
                    Spacer()
                }
                
                VStack{
                    Spacer()
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 10)
                }
                
                
            }

            //BUTTON
            HStack{
                Button(action: {
                    //do something
                    //FrontFacingCameraView()
                     self.facebookManager.isUserAuthenticated = .cameraOnboard
                }, label: {
                    Text("Continue")
                        .padding()
                        .foregroundColor(.white)
                        .modifier(CustomBoldBodyFontModifier(size: 20))

                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .background(Color("primary"))
                .cornerRadius(30)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.bottom, 20)
            .padding(.horizontal, 20)
        }//VStack END
        
    }
}

struct CameraTutorialThirdView_Previews: PreviewProvider {
    static var previews: some View {
        CameraTutorialThirdView()
    }
}

