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
    
    //let currentMeasurement = Measurements()
    
    @ObservedObject var measurmentVM =  MeasurementViewModel()
    
    @State private var image : UIImage?
    @ObservedObject var inputImage = ImageFromDirectory()
    @State private var imageName = "com.smr.front.png"
    @EnvironmentObject var facebookManager: FacebookManager
    @EnvironmentObject var currentMeasurement: Measurements

    var body: some View {
//        NavigationView {
            VStack(alignment:.leading) {
//                MainView(imageName: imageName).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (3.5/4))
//                Spacer()
               
                    FrontMainViewController()
                    VStack {
                        Button(action: {
                            self.facebookManager.isUserAuthenticated = .sideBodyMeasurement

                        }, label: {
                            Text("Continue").modifier(CustomBoldBodyFontModifier(size: 20))
                        }).padding(.top, 20).padding(.bottom, 20).foregroundColor(.white)
                        
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("primary"))
                            .cornerRadius(30)
                        .padding().shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
                    }.background(Color(.white)).frame(minWidth: 0, maxWidth: .infinity)
                    
                
                
            }.background(Color(.white)).edgesIgnoringSafeArea(.all)
//                .navigationBarItems(trailing:
//                    NavigationLink(destination: SideMeasurement()) {
//                       // Button("Done").foregroundColor(Color(.black))
//                        Button(action: {
//                            print("Current VM: \(self.measurmentVM.currentMeasurments.frontRightY)")
//                        }, label: {
//                            Text("Done").foregroundColor(Color(.black))
//                        })
//                    }).navigationBarTitle(Text("Front"), displayMode: .inline)

//        }
    }
    
}

struct FrontSideMeasurement_Previews: PreviewProvider {
    
    static var previews: some View {
        FrontSideMeasurement()
    }
}

let currentMeasurments = Measurements()

struct FrontMainViewController: UIViewControllerRepresentable {
    public typealias UIViewControllerType = FrontViewController

    public func makeUIViewController(context: Context) -> FrontViewController {
        let frontviewController = FrontViewController()
        
        frontviewController.frontControlView.delegate = context.coordinator
        return frontviewController
    }
    
    public func updateUIViewController(_ uiViewController: FrontViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
           Coordinator(self)
    }
       
    class Coordinator: NSObject, ControlViewDelegate {
        func newFrontMeasurements(_ top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
            print("Top: \(top)")
        }
        
           var parent: FrontMainViewController
           init(_ parent: FrontMainViewController) {
               self.parent = parent
           }
    
           
        func newMeasurements(_ top: CGFloat, leftX: CGFloat, leftY: CGFloat, bottom: CGFloat, rightX: CGFloat, rightY: CGFloat) {
            print("Top: \(top)")
           currentMeasurments.frontSet = true
           currentMeasurments.frontTop = top
           currentMeasurments.frontLeftX = leftX
           currentMeasurments.frontLeftY = leftY
           currentMeasurments.frontBottom = bottom
           currentMeasurments.frontRightX = rightX
           currentMeasurments.frontRightY = rightY

        }
        
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
