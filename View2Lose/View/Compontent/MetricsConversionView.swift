//
//  MetricsConversionView.swift
//  View2Lose
//
//  Created by Sagar on 22/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI


struct MetricsConversionView: View {
    @Binding var switchMetric : Bool
    var body: some View {
        HStack (alignment: .center) {
            Text ("Imperial")                        .modifier(CustomBodyFontModifier(size: 14))
                
                .foregroundColor(Color("secondary"))
            Toggle(isOn: $switchMetric) {
                Text("")
                
            }
            .labelsHidden()
            .padding()
            Text ("Metric")                        .modifier(CustomBodyFontModifier(size: 14))
                
                .foregroundColor(Color("secondary"))
            
            
            
        }.frame(minWidth: 0, maxWidth: .infinity)
    }
}
