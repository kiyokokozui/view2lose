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
        }
    }
}

struct DashboardTabBar_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabBar()
    }
}
