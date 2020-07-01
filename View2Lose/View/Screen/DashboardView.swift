//
//  DashboardView.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

let screen = UIScreen.main.bounds

enum Weeks: Int, CaseIterable, Identifiable, Hashable{
    case week0
    case week6
    case week12
    case week18


}

extension Weeks {
    var id: UUID {
        return UUID()
    }
    var weekLength: String {
        switch self {
        case .week0:
            return "Week 0"
        case .week6:
            return "Week 6"
        case .week12:
            return "Week 12"
        case .week18:
            return "Week 18"
            
        default:
            return "Week 0"
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var facebookManager: FacebookManager
    @State var isLoggedIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
    
    
    func getUser() {
        session.listen()
    }
    
  
    
    
    var body: some View {
        Group {
            if isLoggedIn {
                //DashboardSectionView()
                //LoginView()
                ContentView(viewModel: UserViewModel())
            } else {
                if facebookManager.isUserAuthenticated == .undefined {
                    LoginView()
                } else if facebookManager.isUserAuthenticated == .userOnBoard {
                    
                    ContentView(viewModel: UserViewModel()).transition(.slide)
                    //TestView()
                } else if facebookManager.isUserAuthenticated == .cameraOnboard {
                    FrontFacingCameraView().transition(.slide)
                } else if facebookManager.isUserAuthenticated == .cameraOnBoard2 {
                    
                    SideFacingCameraView().transition(.slide)
                }else if facebookManager.isUserAuthenticated == .imagePreview{
                    ImagePreview().transition(.slide)
                }else if facebookManager.isUserAuthenticated == .frontBodyMeasurement {
                    FrontSideMeasurement().transition(.slide)
                
                } else if facebookManager.isUserAuthenticated == .sideBodyMeasurement {
                   SideMeasurement()
                } else if facebookManager.isUserAuthenticated == .signedIn {
                    DashboardSectionView().transition(.slide)
                    
                } else if facebookManager.isUserAuthenticated == .postOnBoardLoading {
                    PostOnBoardingLoadingView()
                }
            }
        }.onAppear(perform: getUser)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView().environmentObject(FacebookManager())
    }
}

struct DashboardSectionView: View {
    @State private var selectedItem = 1
    @State var desiredWeight: Double = 50
    @State var showActionSheet: Bool = false
    @State var showingImagePicker = false
    @State var image: Image? = nil
    
    @State var index = 0
    @State private var selectedWeek = 1
    var weeks = ["Week 0", "Week 6", "Week 12", "Week 18"]



    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Photo Picker"), message: Text("Choose option"), buttons: [
            .default(Text("Take Photo")),
            .default(Text("Photo Library"), action: {
                self.showingImagePicker.toggle()
                ImagePicker.shared.view
            }),
            .destructive(Text("Cancel"))
        ])
    }
    
    init() {
          UISegmentedControl.appearance().selectedSegmentTintColor = .white
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"primary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .selected)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"secondary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .normal)
      }
    
    func loadWarpImages() -> [UIImage] {
        var tempFillArray: [UIImage] = []
        let fileURL = try! FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("/com.bbi.warpedImages")
        print(fileURL)
        
        if let nsData = NSData(contentsOf: fileURL) {

            guard let warpedImageString = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: nsData as Data) else {
                fatalError("warpedImageString - Can't encode data")
            }
            
            for imageData in warpedImageString {
               // let imageData = NSData(base64Encoded: imageString, options: NSData.Base64DecodingOptions(rawValue: 0))
                if (imageData != nil) {
                    let processedImage = UIImage(data: imageData as! Data)
                    if (processedImage != nil) {
                        tempFillArray.append(processedImage!)
                        
                    }
                }
            }
            return tempFillArray
            
        }
        return []
    }

    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
               // Image("bg_pattern").resizable().frame(width: screen.width, height: 400).aspectRatio(contentMode: .fit)
                Text("MyView").modifier(CustomBodyFontModifier(size: 35))
                    .padding(.vertical, 20).foregroundColor(.white).padding(.leading, 20)
            
            
        
        
            VStack (alignment: .leading, spacing: 10) {
//                HStack {
//                    Text("Your better \nbody image")
//                        .font(.system(size: 40))
//                        .fontWeight(.bold)
//                        .lineLimit(2)
//                        .multilineTextAlignment(.leading)
//
//                }
                Picker("",selection:$selectedWeek) {
                                                             ForEach(0 ..< weeks.count ) { index in
                                                                 //Text(week.weekLength).tag(week).foregroundColor(Color("primary"))
                                                                 Text(self.weeks[index]).tag(index)
                                                             }
                }.pickerStyle(SegmentedPickerStyle()).background(Color(#colorLiteral(red: 0.9490196078, green: 0.9254901961, blue: 1, alpha: 1))).cornerRadius(1).padding(.top, 20)
                VStack {
                    ZStack (alignment: .topLeading) {
                        
                        VStack {
                           
                            if image == nil {
                                
                                Image(uiImage: loadWarpImages()[selectedWeek])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .padding(20)
                                
                                //)Image("woman-placeholder")
//                                ScrollView {
//                                    Image(uiImage: loadWarpImages()[1])
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    //.opacity(0.4)
//                                    .padding(20)
//
//                                    Image(uiImage: loadWarpImages()[2])
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    //.opacity(0.4)
//                                    .padding(20)
//
//                                    Image(uiImage: loadWarpImages()[3])
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    //.opacity(0.4)
//                                    .padding(20)
//
//
//                                }
                                

                            } else {
                                image?.resizable()
                                .aspectRatio(contentMode: .fill)
                            }
                                                        
                        } .frame(width: screen.width - 30,height: 450, alignment: .center)

                            .background(Color(#colorLiteral(red: 0.9198947021, green: 0.9198947021, blue: 0.9198947021, alpha: 1)))
                        
                       
                      
//
//                        VStack {
//                            Button(action: {
//                                self.showActionSheet.toggle()
//                            }) {
//                                HStack(alignment: .center, spacing: 7) {
//                                    Image(systemName: "camera").resizable()
//                                        .renderingMode(.template)
//                                        .foregroundColor(Color(.white))
//                                        .frame(width: 12, height: 12)
//                                        .aspectRatio(contentMode: .fill)
//                                    Text( image == nil ? "Take Picture" : "Retake")
//                                        .font(.system(size: 12))
//                                        .foregroundColor(Color(.white))
//                                }
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 10)
//                            }
//                            .background(Color("primary"))
//                            .cornerRadius(20)
//                            .actionSheet(isPresented: $showActionSheet, content: {
//                                                      self.actionSheet })
//                                .sheet(isPresented: $showingImagePicker, onDismiss: {
//                                    //TestView()
//                                    print("Image Picker Dismissed")
//                                }, content: {
//                                ImagePicker.shared.view
//                            }).onReceive(ImagePicker.shared.$image) { (image) in
//                                self.image = image
//                            }
//                        }.padding(15)
                        
                        
                        
                    }.padding(.vertical, 10)
                    
                    
                
                    
                }
                Spacer()
              
//                VStack {
//                    //SliderViewDashboard(percentage: $desiredWeight, hideTicker: false, range: (40, 120))
//
//                    Divider()
//                    HStack {
//                        Button(action: {
//                            self.index = 0
//                        }) {
//                            Image(systemName: "hexagon")
//                                .resizable().frame(width: 25, height: 25)
//                        }.foregroundColor(Color("primary"))
//                        Spacer(minLength: 0)
//
//                        Button(action: {
//                            self.index = 1
//                        }) {
//                            Image(systemName: "heart")
//                            .resizable().frame(width: 25, height: 25)
//
//
//                        }.foregroundColor(Color("primary"))
//                        Spacer(minLength: 0)
//
//                        Button(action: {
//                            self.index = 2
//                        }) {
//                            Image(systemName: "hexagon")
//                        .resizable().frame(width: 25, height: 25)
//
//                        }.foregroundColor(Color("primary"))
//                        Spacer(minLength: 0)
//
//                        Button(action: {
//                            self.index = 3
//                        }) {
//                            Image(systemName: "person")
//                        .resizable().frame(width: 25, height: 25)
//
//                        }.foregroundColor(Color("primary"))
//
//                        }
//                    .background(Color("red"))
//                        .padding(.horizontal, 35).frame(width: UIScreen.main.bounds.width - 40, height: 40)
//
//                }.frame(minWidth: 0, maxHeight: .infinity)
//                    .padding(.horizontal, 20)
//
                
                
                }.padding().background(Color(.white)).clipShape(Rounded())
            
        }.frame(minWidth: 0, maxWidth: .infinity).background(Color("primary")).edgesIgnoringSafeArea(.top)

                
            
        
    
    }
}

struct Rounded: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 40, height: 40))
        return Path(path.cgPath)
    }
}



