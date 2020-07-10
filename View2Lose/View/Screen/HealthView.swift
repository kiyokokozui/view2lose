//
//  HealthView.swift
//  View2Lose
//
//  Created by Sagar on 1/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Charts

struct LineChartSwiftUI: UIViewRepresentable {
    
    let lineChart = LineChartView()
    
    func makeUIView(context: UIViewRepresentableContext<LineChartSwiftUI>) -> LineChartView {
        setUpChart()
        return lineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<LineChartSwiftUI>) {
        
    }
    
    func setUpChart() {
        lineChart.noDataText = "No Data Available"
        let dataSets = [getLineChartDataSet()]
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChart.data = data
        
//        lineChart.xAxis.enabled = false
        lineChart.xAxis.drawLabelsEnabled = false
        lineChart.leftAxis.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
//        lineChart.xAxis.drawGridLinesEnabled = true
    }
    
    func getChartDataPoints(sessions: [Double], accuracy: [Double])  -> [ChartDataEntry] {
        var dataPoints: [ChartDataEntry] = []
        for count in (0..<sessions.count) {
            dataPoints.append(ChartDataEntry(x: sessions[count], y: accuracy[count]))
        }
        return dataPoints
    }
    
    /// This function returns a welcoming string for a given `subject`.
    ///
    /// ```
    /// print(hello("World")) // Hello, World!
    /// ```
    ///
    /// - Warning: The returned string is not localized.
    /// - Parameter subject: The subject to be welcomed.
    /// - Returns: A hello string to the `subject`.
    func getLineChartDataSet() -> LineChartDataSet {
        let dataPoints = getChartDataPoints(sessions: [1.0 , 2.0 , 3.0 , 4.0], accuracy: [58.0 , 57.0 , 55.0 , 54.0])
        let set = LineChartDataSet(entries: dataPoints)
        set.lineWidth = 2.5
        set.circleRadius = 8
        set.circleHoleRadius = 5
        let color = UIColor(named: "primary")
        set.setColor(color!)
        set.setCircleColor(color!)
        return set
    }
}

struct HealthView: View {
    @State private var expandWeight = false
    @State private var expandBMI = false
    @State private var expandWaist = false
    
    var body: some View {
        TabView {
            VStack(alignment: .leading) {
                Text("My Health").modifier(CustomBodyFontModifier(size: 35))
                    .padding(.vertical, 20).foregroundColor(.white).padding(.leading, 20).padding(.top, 20)
                
                ScrollView {
                    VStack (spacing: 30) {
                        ZStack (alignment: .leading) {
                           Rectangle().foregroundColor(.white)}.frame(height: 1)
                        
                        //WEIGHT
                        ZStack (alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .shadow(radius: 5)
                            
                            VStack (alignment: .leading) {
                                HStack (alignment: .lastTextBaseline, spacing: expandWeight ? 170 : 230, content: {
                                   Text(expandWeight ? "Current Weight" : "Weight")
                                        .font(.body)
                                        .foregroundColor(Color("primary"))
                                    
                                    Image(systemName: expandWeight ? "chevron.up" : "chevron.down")
                                        .foregroundColor(Color("primary"))
                                })
                                
                                if expandWeight {
                                    HStack {
                                        Text("58kg")
                                             .foregroundColor(.black)
                                        Spacer()
                                        Text("57kg")
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("55kg")
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("54kg")
                                            .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity)

                                    HStack {
                                        LineChartSwiftUI()
                                    }

                                    HStack {
                                       Text("April 2")
                                            .foregroundColor(.black)
                                       Spacer()
                                       Text("May 3")
                                           .foregroundColor(.black)
                                       Spacer()
                                       Text("June 10")
                                           .foregroundColor(.black)
                                       Spacer()
                                       Text("July 7")
                                           .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(20)
                            .multilineTextAlignment(.leading)
                        }
                        .foregroundColor(.white)
                        .frame(height: expandWeight ? 300 : nil)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            self.expandWeight.toggle()
                        }
                        .animation(.linear(duration: 0.1))
                        
                        //BMI CALCULATOR
                        ZStack (alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .shadow(radius: 10)

                            VStack (alignment: .leading) {
                                HStack (alignment: .firstTextBaseline, spacing: 170, content: {
                                    Text("BMI Calculator")
                                        .font(.body)
                                        .foregroundColor(Color("primary"))
                                    
                                    Image(systemName: expandBMI ? "chevron.up" : "chevron.down")
                                    .foregroundColor(Color("primary"))
                                })
                                
                                if expandBMI {
                                    HStack (alignment: .firstTextBaseline) {
                                        Text("24.5")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(.black)
                                        
                                        Text("You're Healthy")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }
                                    
                                    ZStack (alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .foregroundColor(.green)
                                        
                                        Rectangle()
                                            .foregroundColor(.gray)
                                            .frame(width: 5, height: 20)
                                            .padding(.leading, 20)
                                    }
                                    .frame(height: 20)
                                    
                                    Spacer()
                                    
                                    Text("A BMI from 18.5 - 24.9 indicates that you are at a healthy weight for your height. By maintaining a healthy weight, you lower your risk of developing health problems.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(20)
                            .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .frame(height: expandBMI ? 250 : nil)
                        .onTapGesture {
                            self.expandBMI.toggle()
                        }
                        .animation(.linear(duration: 0.1))
                        
                        //WAIST MEASUREMENT
                        ZStack (alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .shadow(radius: 10)

                            VStack (alignment: .leading) {
                                HStack (alignment: .firstTextBaseline, spacing: 130, content: {
                                    Text("Waist Measurement")
                                        .font(.body)
                                        .foregroundColor(Color("primary"))
                                    
                                    Image(systemName: expandWaist ? "chevron.up" : "chevron.down")
                                    .foregroundColor(Color("primary"))
                                })

                                if expandWaist {
                                    GeometryReader { geo in
                                        HStack (spacing: 10){
                                            Image("bodywithredline")
                                                .resizable()
                                                .frame(width: geo.size.width / 4.5, height: geo.size.height/1.5)
                                            VStack {
                                                HStack {
                                                    Text("58kg")
                                                        .foregroundColor(Color("primary"))
                                                    Spacer()
                                                    Text("57kg")
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                    Text("55kg")
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                    Text("54kg")
                                                        .foregroundColor(.black)
                                                    }
                                                    .frame(maxWidth: .infinity)

                                                HStack {
                                                    LineChartSwiftUI()
                                                }

                                                HStack {
                                                   Text("April 2")
                                                        .foregroundColor(.black)
                                                   Spacer()
                                                   Text("May 3")
                                                       .foregroundColor(.black)
                                                   Spacer()
                                                   Text("June 10")
                                                       .foregroundColor(.black)
                                                   Spacer()
                                                   Text("July 7")
                                                       .foregroundColor(.black)
                                                }
                                                .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            .padding(20)
                            .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .frame(height: expandWaist ? 300 : nil)
                        .onTapGesture {
                            self.expandWaist.toggle()
                        }
                        .animation(.linear(duration: 0.1))
                    }
                    .padding()
                }
//                .padding()
                .background(Color(.white))
                .clipShape(Rounded())
                
            }.frame(minWidth: 0, maxWidth: .infinity).background(Color("primary")).edgesIgnoringSafeArea(.top)
            .tabItem({
                Image("rsz_ic_myview")
                Text("My View")
                }).tag(0)
            
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

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
