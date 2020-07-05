//
//  PostOnBoardingLoadingView.swift
//  View2Lose
//
//  Created by Sagar on 30/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import SwiftyGif


struct PostOnBoardingLoadingView: View {
    
    @State var play = true



    var body: some View {
//        VStack {
//                Text("Just a moment").modifier(CustomBoldBodyFontModifier(size: 26)).padding(.bottom, 20)
//                Text("We are uploading your photos").modifier(CustomBodyFontModifier(size: 20))
//
////               // Image(self.Gif1!.imageAtIndex(index: self.counter1.frameNo)!,
////                scale: CGFloat(self.Gif1!.pixelWidth) / geometry.size.width,
////                label: Text(""))
//
//              //  Image(uiImage: UIImage.gifImageWithName("LoadingAnimation")!).resizable().frame(width: 200, height: 200)
//            }
        VStack{
                   Text("Just a Moment")
                       .modifier(CustomBoldBodyFontModifier(size: 35))
                       .padding(.bottom, 20)
                       .padding(.top, 100)
                   Text("We are uploading your photos")
                    .foregroundColor(Color("secondary"))
                    .modifier(CustomBoldBodyFontModifier(size: 20))
                   
                   GifView(gifName: "loadingGif", play: $play)
                       .padding(30)
                   
                   Spacer()
        }
        
    }
}

struct PostOnBoardingLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        PostOnBoardingLoadingView()
    }
}


