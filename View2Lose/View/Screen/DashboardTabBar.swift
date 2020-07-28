//
//  DashboardTabBar.swift
//  View2Lose
//
//  Created by Sagar on 1/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct DashboardTabBar: View {
    var body: some View {
        TabView {
            DashboardView().tabItem({
                Image("Logo")
            })
            HealthView().tabItem({
                Image(systemName: "chart.bar.fill")
                Text("My Health")
            }).tag(1)
            Update().tabItem({
                //Image("ruler").resizable().renderingMode(.template).foregroundColor(Color("secondary")).frame(width: 32, height: 32)
                Image(systemName: "plus.square.fill")
                
                Text("Update")
            }).tag(2)
            ChatBot().tabItem({
                Image(systemName: "bubble.right.fill")
                Text("Chat Bot")
            }).tag(3)
            SettingsView().tabItem({
                Image(systemName: "gear")
                Text("Settings")
            }).tag(4)
        }
    }
}

struct DashboardTabBar_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabBar()
    }
}
