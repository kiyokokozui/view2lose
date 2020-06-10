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
                navView().padding(.top, -30)
                Text("What's your \nactivity level? ")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
                    .modifier(CustomHeaderFontModifier(size: 28))
                    .padding(.bottom, 20)
                    .lineLimit(2)
                
                Text("Describe your activity level")
                    .foregroundColor(Color.init(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                VStack{
                    ActivityListView()

                    
                }

                Spacer()
                HStack(alignment: .center) {
                        NavigationLink(destination: UserGoalView()) {
                            Text("Continue")
                                .padding()
                                .foregroundColor(.white)
                            
                            .frame(maxWidth: .infinity, alignment: .center)
                        }.background(Color("primary"))
                        .cornerRadius(30)
                        
                  
                    
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 10)

            }.padding(.horizontal, 20)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: bckButton.padding(.leading, 5))
        
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}

struct ActivityListView: View {
    @State var selected = 0
    
    var body: some View {
       
        return ForEach(0 ..< activityData.count) { index in
            Button(action: {
                self.selected = index
            })  {
                VStack(alignment: .center,spacing: 10) {
                    
                    Text(activityType[index])
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color("primary"))

                    
                    Text(activityData[index])
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                        .lineLimit(2)
                    
                }
                .padding(.vertical, 20)
                
            }
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 20)

                .shadow(color: self.selected == index ? Color("primary") : Color("secondary"), radius: 2, x: 1, y: 2)
                .shadow(color: self.selected == index ? Color("primary") : Color("secondary"), radius: 2, x: 1, y: -1)

        }
        
        
    }
}

struct navView: View {
    var body: some View {
        HStack {
            HStack (alignment: .center, spacing: 10) {
                
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("secondary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("primary"))
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("secondary"))
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color("secondary"))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}
