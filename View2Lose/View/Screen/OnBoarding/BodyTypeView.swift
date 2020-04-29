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
    
    func getMid() -> Int {
        return bodyTypes.count / 2
    }
    
    
    
    private func scrollView(reader: GeometryProxy) -> some View {
            HStack  (alignment: .center) {
                               ForEach(0..<5) { i in
                                       cardView(image: "Apple")
                                    .highPriorityGesture(DragGesture()
                                        .onChanged( { (value) in
                                            if value.translation.width > 0 {
                                                self.x = value.location.x
                                            } else {
                                                self.x = value.location.x + self.screen
                                            }
                                            
                                        })
                                        .onEnded({ (value) in
                                            if value.translation.width > 0 {
                                                if value.translation.width > ((self.screen - 80) / 2) && Int(self.count) != self.getMid() {
                                                    self.count += 1
                                                    self.x = (self.screen + 15) * self.count
                                                } else {
                                                    self.x = (self.screen + 15) * self.count

                                                }
                                            } else {
                                                if -value.translation.width > ((self.screen - 80) / 2) && Int(self.count) != self.getMid() {
                                                    self.count += 1
                                                    self.x = (self.screen + 15) * self.count
                                                } else {
                                                    self.x = (self.screen + 15) * self.count

                                                }
                                            }
                                            
                                        })
                                    )
                                    
                                    
                                    
                                    
                                           //.rotation3DEffect(Angle(degrees: Double(reader.frame(in: .global).minX - 40) / -20 ), axis: (x: 0, y: 10.0, z: 0))
                                     
                                   


                               }
                           

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
            
            Text("What's your \nbody type?")
//                .font(.largeTitle)
//                .fontWeight(.bold)
                .lineLimit(2)
                .padding(.leading, 20)
            .modifier(CustomHeaderFontModifier(size: 35))

            
            VStack {
//                HStack {
//                  // BodyTypeButton()
//
//                }
//                GeometryReader { reader in
//                    self.scrollView(reader: reader)
//                }
                Spacer()
//
                CarouselView(itemHeight: 350, views: [

                    AnyView(
                        VStack {
                            Image("Banana").resizable().aspectRatio(contentMode: .fit)
                        }

                    ),
                    AnyView(
                        VStack {
                            Image("Apple").resizable().aspectRatio(contentMode: .fit)
                        }

                    ),
                    AnyView(
                        VStack {
                            Image("Potato").resizable().aspectRatio(contentMode: .fit)
                        }

                    ),
                    AnyView(
                        VStack {
                            Image("Pear").resizable().aspectRatio(contentMode: .fit)
                        })

                ])
                    
    
                
            }.frame(width: UIScreen.main.bounds.width, height: 350)
                .padding(.vertical, 10)
            Spacer()
            HStack(alignment: .center) {
                Button(action: {
                    self.facebookManager.isUserAuthenticated = .signedIn
                    DashboardView()
                }, label: {
                    Spacer()
                        Text("Complete")
                            .padding()
                            .foregroundColor(.white)

                        .frame(maxWidth: .infinity, alignment: .center)


                })
                .background(Color("primary"))
                    .cornerRadius(30)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
             
            }.frame(minWidth: 0, maxWidth: .infinity)
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

var bodyTypes = [
    BodyType(name: "Pear", imageName: "Pear"),
    BodyType(name: "Apple", imageName: "Apple"),
    BodyType(name: "Banana", imageName: "Banana"),
    BodyType(name: "Potato", imageName: "Potato")

]

//var bodyTypes = [["Pear", "Apple"], [ "Banana", "Potato"]]


//struct BodyTypeButton: View {
//
//    @State var selected = ""
//    @State var show = false
//    var body: some View {
//        ForEach(0..<bodyTypes.count) { i in
//            Group {
//                VStack (alignment: .leading) {
//                ForEach(bodyTypes[i], id: \.self) { image in
//                    //Text(image)
//                    self.createView(image: image, originalIndex: i)
//                    .padding(.bottom, 10)
//                }
//
//                }.padding()
//                Spacer()
//
//
//            }
//        }
//
//
//    }
    
//    func createView(image: String, originalIndex: Int) -> some View {
//        return VStack(alignment: .center, spacing: 10) {
//            Image("\(image)").renderingMode(.original).resizable().aspectRatio(contentMode: .fit)
//            Text(image)
//        }.padding()
//            .frame(width: 170, height: 170)
//            .background(Color.white)
//            .cornerRadius(10)
//
//        //                self.selected = i
//
//            .shadow(color: self.selected == image ?  Color("primary") : Color("secondary"), radius: 5, x: 1, y: 5)
//        .shadow(color: self.selected == image ?  Color("primary") : Color("secondary"), radius: 2, x: 1, y: -1)
//            .onTapGesture {
//                print("\(image)Button is tapped")
//                self.selected = image
//        }
//
//    }
    
    


struct cardView: View {
    var image = ""
    
    var body: some View{
            VStack  {
                Image(self.image)
                    .resizable()

                    .aspectRatio(contentMode: .fit)

                
                    

        } .cornerRadius(3)

            .shadow(radius: 5)
        .frame(width: UIScreen.main.bounds.width - 40, height: 280)

            


        
        

    }
}

