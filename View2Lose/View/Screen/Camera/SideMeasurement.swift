//
//  SideMeasurement.swift
//  View2Lose
//
//  Created by Sagar on 25/5/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI



struct SideMeasurement: View {
    
    @State private var image : UIImage?
    @ObservedObject var inputImage = ImageFromDirectory()
    @State private var imageName = "com.smr.side.png"
    var body: some View {
            VStack(alignment:.leading) {
                MainView(imageName: imageName).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (3.5/4))
                Spacer()
            }.background(Color(.black))
                .navigationBarItems(trailing: Button(action: {}, label: {Text("Done").foregroundColor(Color(.black))}))
                .navigationBarTitle(Text("Side"), displayMode: .inline)
        
    }
}

struct SideMeasurement_Previews: PreviewProvider {
    
    static var previews: some View {
        FrontSideMeasurement()
    }

}
