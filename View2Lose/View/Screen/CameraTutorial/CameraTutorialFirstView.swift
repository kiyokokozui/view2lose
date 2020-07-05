//
//  CameraTutorialFirstView.swift
//  View2Lose
//
//  Created by purich purisinsits on 10/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct CameraTutorialFirstView: View {
    init() {
        UINavigationBar.appearance().tintColor = .black

    }
    var body: some View {
        NavigationView{
            VStack (alignment: .center, spacing: 10) {
                HStack {
                    // CIRCLE TAB
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
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.top, -30)
                }
                // DESCRIPTION
                //HEADER
                Text("Let's get started")
                    .modifier(CustomHeaderFontModifier(size: 35))
                //SUB HEADER
                Text("This photo taking tutorial will help you visualise your weight loss goals")
                    .foregroundColor(Color("secondary"))
                    .multilineTextAlignment(.center)
                .modifier(CustomBodyFontModifier(size: 16))

                
                Spacer()
                
                //IMAGE
                Image("tutorial screen 1 illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(0)
                
                Spacer()
                
                //FOOTER
                Text("Firstly, find yourself a buddy to help assist you to take a photo.")
                    .foregroundColor(Color("secondary"))
                    .padding()
                    .multilineTextAlignment(.center)
                .modifier(CustomBodyFontModifier(size: 16))

                
                //BUTTON
                HStack{
                    NavigationLink(destination: CameraTutorialSecondView()){
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
            .navigationBarTitle("", displayMode: .inline)
        }
        //NavView END
    }
}

struct CameraTutorialFirstView_Previews: PreviewProvider {
    static var previews: some View {
        CameraTutorialFirstView()
    }
}
