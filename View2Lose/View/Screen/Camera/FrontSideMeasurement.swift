//
//  FrontSideMeasurement.swift
//  View2Lose
//
//  Created by Sagar on 21/5/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

class ImageFromDirectory: ObservableObject {
    var didChange = PassthroughSubject<UIImage, Never>()
    var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }
    
    init() {
        let filename = getDocumentsDirectory().appendingPathComponent("com.smr.front.png")
           if let image = UIImage(contentsOfFile: filename) {
            print("image \(image)")
               self.image = image
           }
        
    }
    
    private func getDocumentsDirectory() -> NSString {
              let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
              let documentsDirectory = paths[0]
              return documentsDirectory as NSString
          }
    
       
}



struct FrontSideMeasurement: View {
    
    @State private var image : UIImage?
    @ObservedObject var inputImage = ImageFromDirectory()
    @State private var imageName = "com.smr.front.png"
    var body: some View {
        NavigationView {
            VStack(alignment:.leading) {
                MainView(imageName: imageName).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (3.5/4))
                Spacer()
            }.background(Color(.black))
                .navigationBarItems(trailing:
                    NavigationLink(destination: SideMeasurement()) {
                        Text("Done").foregroundColor(Color(.black))
                    }).navigationBarTitle(Text("Front"), displayMode: .inline)

        }
    }
}

struct FrontSideMeasurement_Previews: PreviewProvider {
    
    static var previews: some View {
        FrontSideMeasurement()
    }
}


public struct MainView: UIViewRepresentable {
    //@ObservedObject var inputImage = ImageFromDirectory()
    @State var imageName: String?
    
    
    private func getDocumentsDirectory() -> NSString {
           let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
           let documentsDirectory = paths[0]
           return documentsDirectory as NSString
       }
    public func makeUIView(context: Context) -> MainControlView {
        let view = MainControlView(imageName: imageName!)
        //view.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    public func updateUIView(_ uiView: MainControlView, context: Context) {
        
    }
    
    public typealias UIViewType = MainControlView
    
    
    
}
