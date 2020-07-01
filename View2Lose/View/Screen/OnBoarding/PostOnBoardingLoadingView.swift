//
//  PostOnBoardingLoadingView.swift
//  View2Lose
//
//  Created by Sagar on 30/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct PostOnBoardingLoadingView: View {
    @State private var Gif1 : AnimatedGifObject? = nil
    @ObservedObject var counter1 = FrameCounter()
    
    init() {
//        self.counter1.stopTimer()
//        Gif1 = AnimatedGifObject.init(url: Bundle.main.url(forResource: "LoadingAnimation", withExtension: "gif")!)
//        if   Gif1!.frameCount > 5
//        {
//            counter1.startTimerWith(thisMaxFrameCount: Gif1!.frameCount)
//        }
    }


    var body: some View {
        VStack {
                Text("Just a moment").modifier(CustomBoldBodyFontModifier(size: 26)).padding(.bottom, 20)
                Text("We are uploading your photos").modifier(CustomBodyFontModifier(size: 20))
                
//               // Image(self.Gif1!.imageAtIndex(index: self.counter1.frameNo)!,
//                scale: CGFloat(self.Gif1!.pixelWidth) / geometry.size.width,
//                label: Text(""))
                
              //  Image(uiImage: UIImage.gifImageWithName("LoadingAnimation")!).resizable().frame(width: 200, height: 200)
            }
        
        
    }
}

struct PostOnBoardingLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        PostOnBoardingLoadingView()
    }
}

class FrameCounter: ObservableObject
{
    @Published var frameNo  : Int = 0
        
    private var maxFrame    : Int = 0
    
    var timer = Timer()
    
    func startTimerWith(thisMaxFrameCount : Int)
    {
        self.timer.invalidate()
        self.maxFrame   = thisMaxFrameCount
        self.timer      = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true)
                            { timer in
                                self.frameNo += 1
                                if self.frameNo >= self.maxFrame { self.frameNo = 0 }
                            }
    }
    
    func repeatToZero()
    {
        self.frameNo = 0
    }
    
    func stopTimer()
    {
        self.timer.invalidate()
    }

}



// ================================================
