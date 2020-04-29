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
                    
                    ContentView(viewModel: UserViewModel())
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
    @State var desiredWeight: Double = 50
    @State var showActionSheet: Bool = false
    @State var showingImagePicker = false
    @State var image: Image? = nil
    
    @State var index = 0

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
                                .sheet(isPresented: $showingImagePicker, onDismiss: {
                                    TestView()
                                    print("Image Picker Dismissed")
                                }, content: {
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
                    
                    SliderViewDashboard(percentage: $desiredWeight, hideTicker: false, range: (40, 120))
                    
                    Divider()
                    HStack {
                        Button(action: {
                            self.index = 0
                        }) {
                            Image(systemName: "hexagon")
                                .resizable().frame(width: 25, height: 25)
                        }.foregroundColor(Color("primary"))
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            self.index = 1
                        }) {
                            Image(systemName: "heart")
                            .resizable().frame(width: 25, height: 25)

                        
                        }.foregroundColor(Color("primary"))
                        Spacer(minLength: 0)

                        Button(action: {
                            self.index = 2
                        }) {
                            Image(systemName: "hexagon")
                        .resizable().frame(width: 25, height: 25)

                        }.foregroundColor(Color("primary"))
                        Spacer(minLength: 0)

                        Button(action: {
                            self.index = 3
                        }) {
                            Image(systemName: "person")
                        .resizable().frame(width: 25, height: 25)

                        }.foregroundColor(Color("primary"))

                        }
                    .background(Color("red"))
                        .padding(.horizontal, 35).frame(width: UIScreen.main.bounds.width - 40, height: 40)
                    
                }.frame(minWidth: 0, maxHeight: .infinity)
                    .padding(.horizontal, 20)

                
            }.padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                
            
        
    
    }
}



