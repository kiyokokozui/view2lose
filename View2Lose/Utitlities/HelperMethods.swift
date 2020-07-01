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
      
 enum unitType  {
      case height
      case weight
  }

func changeMetrics(metricType: MetricType, unit: unitType, value: Double) -> Double {
    
    
    if metricType == .imperial {
        if unit == .height {
            //Change t
                            let changedMeasurement = Measurement(value:value, unit: UnitLength.centimeters)
                            let changedValue = changedMeasurement.converted(to: UnitLength.feet)
            print("Value is \(value) : Changed Value is \(changedValue)")
            return Double(changedValue.value)

        } else {
             let changedMeasurement = Measurement(value: value, unit: UnitMass.pounds)
                            let changedValue = changedMeasurement.converted(to: UnitMass.kilograms)
            print("Value is \(value) : Changed Value is \(changedValue)")

                            return Double(changedValue.value)
        }
        
    } else {
        if unit == .height {
              let changedMeasurement = Measurement(value: value, unit: UnitLength.feet)
                            let changedValue = changedMeasurement.converted(to: UnitLength.centimeters)
            print("Value is \(value) : Changed Value is \(changedValue)")

                            return Double(changedValue.value)
        } else {
            let changedMeasurement = Measurement(value: value, unit: UnitMass.kilograms)
                            let changedValue = changedMeasurement.converted(to: UnitMass.pounds)
            print("Value is \(value) : Changed Value is \(changedValue)")

                            return Double(changedValue.value)
        }
    }
}
