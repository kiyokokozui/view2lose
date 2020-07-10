//
//  BodyTypeView.swift
//  View2Lose
//
//  Created by Sagar on 15/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI



struct BodyTypeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var facebookManager: FacebookManager
    @State private var x: CGFloat = 0
    @State private var count : CGFloat = 0
    @State private var screen = UIScreen.main.bounds.width - 40
    @State var selection: Int? = nil
    @State var selectedImage: String = "Potato"


    var bckButton: some View {
          Button(action: {
              self.presentationMode.wrappedValue.dismiss()
          }) {
              
              Image(systemName: "chevron.left")
                  .foregroundColor(.black)
          }.frame(width: 40, height: 40)
      }
    

    
    var body: some View {

        VStack (alignment: .leading, spacing: 10) {
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
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color("tertiary"))
                
            } //.background(Color("bg-color"))
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, -30)

            
            Text("Select your \nbody type")
//                .font(.largeTitle)
//                .fontWeight(.bold)
                .lineLimit(2)
                .padding(.leading, 20)

            .modifier(CustomHeaderFontModifier(size: 30))
            .minimumScaleFactor(0.7)

            VStack(alignment: .center)  {
                HStack {
                    Spacer()
                    BodyTypeButton(selected: $selectedImage)
                    Spacer()
                }
//                GeometryReader { reader in
//                    self.scrollView(reader: reader)
//                }
                    
    
                
            }
                //.frame(width: UIScreen.main.bounds.width, height: 350)
            Spacer()
            HStack(alignment: .center) {
                //Spacer()
                NavigationLink(destination: UserGoalView(), tag: 1, selection: $selection) {
                    Button(action: {
                        self.selection = 1
                        if self.selectedImage == "Potato" {
                            UserDefaults.standard.set(4, forKey: "BBIBodyTypeKey")
                            
                        } else if self.selectedImage == "Banana" {
                            UserDefaults.standard.set(1, forKey: "BBIBodyTypeKey")

                        } else if self.selectedImage == "Apple" {
                            UserDefaults.standard.set(2, forKey: "BBIBodyTypeKey")

                        } else if self.selectedImage == "Pear" {
                            UserDefaults.standard.set(3, forKey: "BBIBodyTypeKey")

                        }
                    }) {
                       Text("Continue")
                        .padding()
                        .foregroundColor(.white)
                        .modifier(CustomBoldBodyFontModifier(size: 20))

                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                }.background(Color("primary"))
                    .cornerRadius(30)
                    .padding(.bottom, 20)
            }.frame(minWidth: 0, maxWidth: .infinity).padding(.horizontal, 20)
//            HStack(alignment: .center) {
//                Spacer()
//                  NavigationLink(destination: FrontFacingCameraView()) {
//                                          Text("Continue")
//                                              .padding()
//                                              .foregroundColor(.white)
//
//                                              .frame(maxWidth: .infinity, alignment: .center)
//                                      }.background(Color("primary"))
//                                          .cornerRadius(30)
//                                      .padding(.bottom, 10)
//            }.frame(minWidth: 0, maxWidth: .infinity)
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: bckButton.padding(.leading, -5))
        //self.facebookManager.isUserAuthenticated = .signedIn
       // .background(Color("bg-color"))


    }
    
}
  


struct BodyTypeView_Previews: PreviewProvider {
    static var previews: some View {
        BodyTypeView()
    }
}

struct BodyType {
    public var name: String
    public var imageName: String
}

//var bodyTypes = [
//    BodyType(name: "Pear", imageName: "Pear"),
//    BodyType(name: "Apple", imageName: "Apple"),
//    BodyType(name: "Banana", imageName: "Banana"),
//    BodyType(name: "Potato", imageName: "Potato")
//
//]

var bodyTypes = [["Potato", "Apple"], [ "Banana", "Pear"]]

var bodyTypeText = [
    "Potato" : "Extra weight stored around the belly",
    "Banana" : "Extra weight distributed throughout the body",
    "Apple" : "Extra weight stored in the lower body",
    "Pear" : "Does not tent to store extra weight"
]

struct BodyTypeButton: View {

    @Binding var selected:String
    @State var show = false
    var body: some View {
        ForEach(0..<bodyTypes.count) { i in
            VStack {
            Group {
                VStack (alignment: .center) {
                ForEach(bodyTypes[i], id: \.self) { image in
                    //Text(image)
                    self.createView(image: image, originalIndex: i).padding(.bottom, 5)
                }

                }
                .padding()


            }
        }
        }


    }
    
    func createView(image: String, originalIndex: Int) -> some View {
        return VStack {
            VStack(alignment: .center, spacing: 10) {
                Image("\(image)").renderingMode(.original).resizable().aspectRatio(contentMode: .fit)
           
            }.padding()
                .frame(maxWidth: 154, maxHeight: 184)
                .frame(minWidth: 120, minHeight: 144)
                .background(Color.white)
                .cornerRadius(10)
                //.padding(.bottom,10)

      

            .shadow(color: self.selected == image ?  Color("primary") : Color("tertiary"), radius: 5, x: 1, y: 5)
            .shadow(color: self.selected == image ?  Color("primary") : Color("tertiary"), radius: 2, x: 1, y: -1)
            
            Text("\(bodyTypeText[image]!)")

                .modifier(CustomBodyFontModifier(size: 14))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(self.selected == image ? Color("primary") : Color("secondary"))
                //.padding(.bottom, 25)
                //.padding(.horizontal, 5)
               .frame(maxHeight: 400)
            .minimumScaleFactor(0.9)

                //.frame(minHeight: 400)
            //.minimumScaleFactor(0.8)
            .fixedSize(horizontal: false, vertical: true)

            
            //.frame(maxWidth: .infinity, alignment: .center)


        }
        //.padding(.bottom, 10)

            .onTapGesture {
                print("\(image)Button is tapped")
                self.selected = image
        }

    }
    
}
    
    



