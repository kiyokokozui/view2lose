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
                    .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("primary"))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, -30)
            
            Text("What's your \nbody type?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
            
            VStack {
                HStack {
                   BodyTypeButton()
                }
            }
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

var bodyTypes1 = [
    BodyType(name: "Pear", imageName: "Pear"),
    BodyType(name: "Apple", imageName: "Apple"),
    BodyType(name: "Banana", imageName: "Banana"),
    BodyType(name: "Potato", imageName: "Potato")

]

var bodyTypes = [["Pear", "Apple"], [ "Banana", "Potato"]]


struct BodyTypeButton: View {

    @State var selected = ""
    @State var show = false
    var body: some View {
        ForEach(0..<bodyTypes.count) { i in
            Group {
                VStack (alignment: .leading) {
                ForEach(bodyTypes[i], id: \.self) { image in
                    //Text(image)
                    self.createView(image: image, originalIndex: i)
                    .padding(.bottom, 10)
                }
                    
                }
                Spacer()

                
            }
        }
        
        
    }
    
    func createView(image: String, originalIndex: Int) -> some View {
        return VStack(alignment: .center, spacing: 10) {
            Image("\(image)").renderingMode(.original).resizable().aspectRatio(contentMode: .fit)
            Text(image)
        }.padding()
            .frame(width: 170, height: 170)
            .background(Color.white)
            .cornerRadius(10)
            
        //                self.selected = i

            .shadow(color: self.selected == image ?  Color("primary") : Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)), radius: 5, x: 1, y: 5)
        .shadow(color: self.selected == image ?  Color("primary") : Color.init(#colorLiteral(red: 0.7675911784, green: 0.7676092982, blue: 0.7675995827, alpha: 1)), radius: 2, x: 1, y: -1)
            .onTapGesture {
                print("\(image)Button is tapped")
                self.selected = image
        }
        
    }
    
    
}
