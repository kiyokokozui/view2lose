//
//  DashboardView.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

let screen = UIScreen.main.bounds

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
                DashboardSectionView()
                
            } else {
                if facebookManager.isUserAuthenticated == .undefined {
                    LoginView()
                } else if facebookManager.isUserAuthenticated == .userOnBoard {
                    ContentView()
                } else if facebookManager.isUserAuthenticated == .signedIn {
                    
                    DashboardSectionView()
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
    @State var desiredWeight: Float = 50
    @State var showActionSheet: Bool = false
    @State var showingImagePicker = false
    @State var image: Image? = nil

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
    

    var body: some View {
        TabView (selection: $selectedItem) {
            VStack (alignment: .leading, spacing: 10) {
                HStack {
                    Text("Your better \nbody image")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                }
                
                VStack {
                                               
         
                                           
                    ZStack (alignment: .topLeading) {
                        
                       
                        VStack {
                            if image == nil {
                                Image("woman-placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .opacity(0.4)
                                .padding(20)

                            } else {
                                image?.resizable()
                                .aspectRatio(contentMode: .fill)
                            }
                                                        
                        } .frame(width: screen.width - 30,height: 450, alignment: .center)

                            .background(Color(#colorLiteral(red: 0.9198947021, green: 0.9198947021, blue: 0.9198947021, alpha: 1)))
                            .cornerRadius(30)
                        
                       
                      
                        
                        VStack {
                            Button(action: {
                                self.showActionSheet.toggle()
                            }) {
                                HStack(alignment: .center, spacing: 7) {
                                    Image(systemName: "camera").resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color(.white))
                                        .frame(width: 12, height: 12)
                                        .aspectRatio(contentMode: .fill)
                                    Text( image == nil ? "Take Picture" : "Retake")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(.white))
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                            }
                            .background(Color("primary"))
                            .cornerRadius(20)
                            .actionSheet(isPresented: $showActionSheet, content: {
                                                      self.actionSheet })
                            .sheet(isPresented: $showingImagePicker, content: {
                                ImagePicker.shared.view
                            }).onReceive(ImagePicker.shared.$image) { (image) in
                                self.image = image
                            }
                        }.padding(15)
                        
                        
                        
                    }.padding(.vertical, 10)
                    
                    
                
                    
                }
                Spacer()
                VStack {
                    Text("45 Kg")
                    .foregroundColor(Color("primary"))
                    .fontWeight(.bold)
                    
                    SliderView(percentage: $desiredWeight, hideTicker: true)
                }.frame(minWidth: 0, maxHeight: .infinity)
                
                Spacer()
            }.padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                
            
           
            .tabItem {
                    Image(systemName: "hexagon")
                    Text("My View")
            }
            Text("Second Section")
                .tabItem {
                    Image(systemName: "heart")
                    Text("Health")
            }
            Text("Third Section")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
            }
        }
    }
}
