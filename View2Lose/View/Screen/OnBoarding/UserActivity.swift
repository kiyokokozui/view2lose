//
//  UserActivity.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//


import SwiftUI

var activityType = [
    
    "Ligtly Active",
    "Moderately Active",
    "Very Active",
    "Extremely Active"
]

var activityData = [
    
     "Light exercise or sports 1-3 days a week.",
    "Moderate exercise or sports 3-5 days a week.",
    "Hard exercise or sports 6-7 days a week.",
     "Hard daily exercise or sports and physical job."
]



struct ActivityView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selection: Int? = nil
    @State var selectedActivity: Int = 0

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
                navView().padding(.top, -30)
                Text("What's your \nactivity level? ")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
                    .modifier(CustomHeaderFontModifier(size: 30))
                   // .padding(.bottom, 10)
                    .lineLimit(2)
                .minimumScaleFactor(0.6)
                
              
                VStack (alignment: .leading){
                    ActivityListView(selected: self.$selectedActivity)

                    
                }

                Spacer()
                HStack(alignment: .center) {
                        NavigationLink(destination: BodyTypeView(), tag: 1, selection: $selection) {
                            Button(action: {
                               self.selection = 1
                                //We have added +1 because we are saving value starting from 1, in array we have value from index 0
                                UserDefaults.standard.set((self.selectedActivity+1), forKey: "BBIActivityKey")
                            }) {
                            Text("Continue")
                                .padding()
                                .foregroundColor(.white)
                            .modifier(CustomBoldBodyFontModifier(size: 20))

                            .frame(maxWidth: .infinity, alignment: .center)
                            }.buttonStyle(PlainButtonStyle())
                        }.background(Color("primary"))

                        .cornerRadius(30)
                            .shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 10, x: 0, y: 6)
                        
                  
                    
                }
                //.frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 20)

            }.padding(.horizontal, 20)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: bckButton.padding(.leading, -5))
        //.background(Color("bg-color"))


        
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}

struct ActivityListView: View {
    @Binding var selected :Int
    
    var body: some View {
       
        return ForEach(0 ..< activityData.count) { index in
            Button(action: {
                self.selected = index
            })  {
                VStack(alignment: .leading,spacing: 5) {
                    
                    Text(activityType[index])
                    .modifier(CustomBodyFontModifier(size: 17))
                       // .font(.headline)
                      //  .fontWeight(.medium)
                        .foregroundColor(Color("primary"))

                    
                    Text(activityData[index])
//                        .font(.subheadline)
//                        .fontWeight(.light)
                        .modifier(CustomBodyFontModifier(size: 16))

                        .foregroundColor(Color("secondary"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.9)
                        //.padding(.horizontal, 20)
                    
                }
               .padding(.vertical, 20)
                .padding(.horizontal, 20)

                
            }
            .frame(minWidth: 0,maxWidth: .infinity, alignment: .leading)
        .buttonStyle(PlainButtonStyle())
            .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 20)

                .shadow(color: self.selected == index ? Color("primary") : Color("tertiary"), radius: 2, x: 1, y: 2)
                .shadow(color: self.selected == index ? Color("primary") : Color("tertiary"), radius: 2, x: 1, y: -1)
            

        }
        
        
    }
}

struct navView: View {
    var body: some View {
        HStack {
            HStack (alignment: .center, spacing: 10) {
                
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("tertiary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("primary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("tertiary"))
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color("tertiary"))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }        //.background(Color("bg-color"))

    }
}
