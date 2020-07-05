//
//  ImagePreview.swift
//  View2Lose
//
//  Created by Sagar on 24/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

enum ImageDirection: Int, CaseIterable, Identifiable, Hashable{
    case front
    case side
}

extension ImageDirection {
    var id: UUID {
        return UUID()
    }
    var direction: String {
        switch self {
        case .front:
            return "Front"
        case .side:
            return "Side"
            
        }
    }
}


struct ImagePreview: View {
    
//    @State var imageFromDirectory : String?
//
//    init() {
//        self.imageFromDirectory = getDocumentsDirectory().appending("com.smr.front.png")
//    }
    @EnvironmentObject var facebookManager: FacebookManager
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"primary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"white")!, .font : UIFont(name: "Lato-Regular", size: 16)!], for: .normal)
    }

    
    @State private var selectedImageDirection: ImageDirection = .front
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if self.selectedImageDirection == .front {
                        self.facebookManager.isUserAuthenticated = .cameraOnboard
                    } else if self.selectedImageDirection == .side {
                       self.facebookManager.isUserAuthenticated = .cameraOnBoard2
                    }
                }, label: {
                    Text("Retake").foregroundColor(Color("primary")).modifier(CustomBodyFontModifier(size: 16))
                }).padding(.top, 20)
                Spacer()
                Picker("",selection:$selectedImageDirection) {
                    ForEach(ImageDirection.allCases) { imageDirection in
                        Text(imageDirection.direction).tag(imageDirection).foregroundColor(Color("primary"))
                    }
                }.pickerStyle(SegmentedPickerStyle()).background(Color("primary")).frame(width: 200).cornerRadius(7).padding(.top, 20)
                Spacer()
            }.padding(.horizontal,20)
            Image( uiImage: selectedImageDirection == .front ? getImage(name: "com.smr.front.png")! : getImage(name: "com.smr.side.png")!).resizable().frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width * (4/3)).aspectRatio(contentMode: .fit)
            Spacer()
            Button(action: {
                 self.facebookManager.isUserAuthenticated = .frontBodyMeasurement

            }, label: {
                Text("Continue").modifier(CustomBoldBodyFontModifier(size: 20))

            }).padding(.top, 20).padding(.bottom, 20).foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("primary"))
                .cornerRadius(30)
                .padding().shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)

            
        }
    }
    
    
    // MARK: Get Documents Directory
       
       func getDocumentsDirectory() -> NSString {
           let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
           let documentsDirectory = paths[0]
           return documentsDirectory as NSString
       }
    
    func getImage(name: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
          if let image = UIImage(contentsOfFile: filename) {
            //  frontControlView = MainControlView(imageName: )
              return image
          }
        return nil
    }
    
    
}

struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreview()
    }
}
