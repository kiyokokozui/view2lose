//
//  PostOnboardingSuccess.swift
//  View2Lose
//
//  Created by purich purisinsits on 1/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import SwiftyGif

struct PostOnboardingSuccess: View {
    
    @State var play = true
    
    var body: some View {
        
        VStack{
            Text("Just a Moment")
                .modifier(CustomBodyFontModifier(size: 35))
                .padding(.bottom, 20)
                .padding(.top, 100)
            Text("We are uploading your data...")
            .foregroundColor(Color("secondary"))
            
            GifView(gifName: "loadingGif", play: $play)
                .padding(30)
            
            Spacer()
        }
    }
}

struct PostOnboardingSuccess_Previews: PreviewProvider {
    static var previews: some View {
        PostOnboardingSuccess()
    }
}
