//
//  HelperMethods.swift
//  View2Lose
//
//  Created by Sagar on 22/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation


enum MetricType {
      case imperial
      case metric
}
      
 enum unitType : String  {
      case height
      case weight
  }

func changeMetrics(metricType: MetricType, unit: unitType, value: Int) -> Int {
    
    
    if metricType == .imperial {
        if unit == .height {
                            let changedMeasurement = Measurement(value: Double(value), unit: UnitLength.centimeters)
                            let changedValue = changedMeasurement.converted(to: UnitLength.inches)
            
            return Int(changedValue.value)

        } else {
             let changedMeasurement = Measurement(value: Double(value), unit: UnitMass.kilograms)
                            let changedValue = changedMeasurement.converted(to: UnitMass.pounds)
            
                            return Int(changedValue.value)
        }
        
    } else {
        if unit == .height {
              let changedMeasurement = Measurement(value: Double(value), unit: UnitLength.inches)
                            let changedValue = changedMeasurement.converted(to: UnitLength.centimeters)
            
                            return Int(changedValue.value)
        } else {
            let changedMeasurement = Measurement(value: Double(value), unit: UnitMass.kilograms)
                            let changedValue = changedMeasurement.converted(to: UnitMass.pounds)
            
                            return Int(changedValue.value)
        }
    }
}
