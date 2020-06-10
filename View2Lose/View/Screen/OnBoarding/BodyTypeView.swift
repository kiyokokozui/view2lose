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

    var bckButton: some View {
          Button(action: {
              self.presentationMode.wrappedValue.dismiss()
          }) {
              
              Image(systemName: "chevron.left")
                  .foregroundColor(.black)
          }
      }
    

    
    var body: some View {

        VStack (alignment: .leading, spacing: 10) {
            HStack (alignment: .center, spacing: 10) {
                
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("secondary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("secondary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("secondary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("primary"))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, -30)
            
            Text("Select your \nbody type")
//                .font(.largeTitle)
//                .fontWeight(.bold)
                .lineLimit(2)
                .padding(.leading, 20)
            .modifier(CustomHeaderFontModifier(size: 35))

            VStack {
                HStack {
                  BodyTypeButton()

                }
//                GeometryReader { reader in
//                    self.scrollView(reader: reader)
//                }
                    
    
                
            }
                //.frame(width: UIScreen.main.bounds.width, height: 350)
                .padding(.top, 10)
            Spacer()
            HStack(alignment: .center) {
                Button(action: {
                    self.facebookManager.isUserAuthenticated = .cameraOnboard
                    //DashboardView()
                    print("Hello")
                }, label: {
                    Spacer()
                        Text("I am ready!")
                            .padding()
                            .foregroundColor(.white)

                        .frame(maxWidth: .infinity, alignment: .center)


                })
                .background(Color("primary"))
                    .cornerRadius(30)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)

            }.frame(minWidth: 0, maxWidth: .infinity)
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
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: bckButton.padding(.leading, 5))
        //self.facebookManager.isUserAuthenticated = .signedIn

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
    "Potato" : "Chest and belly is where weight is found",
    "Banana" : " Weight is distributed throughout the entire body",
    "Apple" : "Shoulders and hip about the same width",
    "Pear" : "Bottom heavy with weight mainly in buttocks"
]

struct BodyTypeButton: View {

    @State var selected = ""
    @State var show = false
    var body: some View {
        ForEach(0..<bodyTypes.count) { i in
            VStack {
            Group {
                VStack (alignment: .leading) {
                ForEach(bodyTypes[i], id: \.self) { image in
                    //Text(image)
                    self.createView(image: image, originalIndex: i).padding(.bottom, 10)
                }

                }.padding()


            }
        }
        }


    }
    
    func createView(image: String, originalIndex: Int) -> some View {
        return VStack {
            VStack(alignment: .center, spacing: 10) {
                Image("\(image)").renderingMode(.original).resizable().aspectRatio(contentMode: .fit)
           
            }.padding()
                .frame(width: 170, height: 160)
                .background(Color.white)
                .cornerRadius(10)
                //.padding(.bottom,10)


      

            .shadow(color: self.selected == image ?  Color("primary") : Color("secondary"), radius: 5, x: 1, y: 5)
            .shadow(color: self.selected == image ?  Color("primary") : Color("secondary"), radius: 2, x: 1, y: -1)
            
            Text("\(bodyTypeText[image]!)").lineLimit(5)

                .modifier(CustomBodyFontModifier(size: 14))
                .frame(maxHeight: 350)
                .multilineTextAlignment(.center)
                
            
            //.frame(maxWidth: .infinity, alignment: .center)


        }

            .onTapGesture {
                print("\(image)Button is tapped")
                self.selected = image
        }

    }
    
}
    
    



