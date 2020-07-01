//
//  MetricsConversionView.swift
//  View2Lose
//
//  Created by Sagar on 22/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI


struct MetricsConversionView1: View {
    @Binding var switchMetric : Bool
    var body: some View {
        HStack (alignment: .center) {
            Text ("U.S.")
                .modifier(CustomBodyFontModifier(size: 14))
                
                .foregroundColor(self.switchMetric ? Color("secondary") : Color("primary"))
            Toggle(isOn: $switchMetric) {
                Text("Metric")
            }
            .labelsHidden()
            .padding()
            Text ("Metric")
                .modifier(CustomBodyFontModifier(size: 14))
                
                .foregroundColor(self.switchMetric ? Color("primary") : Color("seconday"))
            
            
            
        }.frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct MetricsConversionView: View {
    
    //@Binding var switchMetric : Bool

    var metricsName = ["Metric", "U.S"]
    @State private var switchMetric1 = 1
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"primary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"secondary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .normal)
        
    }
    
    var body: some View {
        Picker("", selection: $switchMetric1) {
            ForEach(0..<metricsName.count) { index in
                Text(self.metricsName[index]).tag(index)                     .modifier(CustomBodyFontModifier(size: 17))

            }
            
            
            }.pickerStyle(SegmentedPickerStyle()).background(Color(#colorLiteral(red: 0.9475272298, green: 0.9246528745, blue: 1, alpha: 1)))
        .frame(width: 175)
    }
}
