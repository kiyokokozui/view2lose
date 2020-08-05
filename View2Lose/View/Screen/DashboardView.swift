//
//  DashboardView.swift
//  View2Lose
//
//  Created by Sagar on 12/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

let screen = UIScreen.main.bounds

enum Weeks: Int, CaseIterable, Identifiable, Hashable {
    case week0
    case week6
    case week12
    case week18
}

extension Weeks {
    var id: UUID {
        return UUID()
    }
    var weekLength: String {
        switch self {
        case .week0:
            return "Week 0"
        case .week6:
            return "Week 6"
        case .week12:
            return "Week 12"
        case .week18:
            return "Week 18"
        default:
            return "Week 0"
        }
    }
}

var downloadedImages: [UIImage] = []

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
                ContentView(viewModel: UserViewModel())
            } else {
                if facebookManager.isUserAuthenticated == .undefined {
                    LoginView()
                } else if facebookManager.isUserAuthenticated == .userOnBoard {
                    ContentView(viewModel: UserViewModel()).transition(.slide)
                } else if facebookManager.isUserAuthenticated == .cameraOnboard {
                    FrontFacingCameraView().transition(.slide)
                } else if facebookManager.isUserAuthenticated == .cameraOnBoard2 {
                    SideFacingCameraView().transition(.slide)
                } else if facebookManager.isUserAuthenticated == .imagePreview{
                    ImagePreview().transition(.slide)
                } else if facebookManager.isUserAuthenticated == .frontBodyMeasurement {
                    FrontSideMeasurement().transition(.slide)
                } else if facebookManager.isUserAuthenticated == .sideBodyMeasurement {
                   SideMeasurement()
                } else if facebookManager.isUserAuthenticated == .signedIn {
                    DashboardSectionView().transition(.slide)
                } else if facebookManager.isUserAuthenticated == .postOnBoardLoading {
                    PostOnBoardingLoadingView()
                } else if facebookManager.isUserAuthenticated == .cameratutorial {
                    CameraTutorialFirstView()
                } else if facebookManager.isUserAuthenticated == .updateMeasurement {
                    UpdateMeasurement()
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
    @State private var selectedWeek = 0

    var weeks = ["Week 0", "Week 6", "Week 12", "Week 18"]

    @State var isWellDone = UserDefaults.standard.bool(forKey: "showWellDonePop")
	
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
    
    init() {
		UISegmentedControl.appearance().selectedSegmentTintColor = .white
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"primary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .selected)
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named:"secondary")!, .font : UIFont(name: "Lato-Regular", size: 16)], for: .normal)
		UITabBar.appearance().tintColor = UIColor(named: "primary")
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "primary")], for:.selected)
    }
    
    func loadWarpImages() -> [UIImage] {
        var tempFillArray: [UIImage] = []
        let fileURL = try! FileManager.default
			.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			.appendingPathComponent("/com.bbi.warpedImages")
        print(fileURL)
        
        if let nsData = NSData(contentsOf: fileURL) {

			guard let warpedImageString = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: nsData as Data) else {
                fatalError("warpedImageString - Can't encode data")
            }
            
            for imageData in warpedImageString {
                if (imageData != nil) {
                    let processedImage = UIImage(data: imageData as! Data)
                    if (processedImage != nil) {
                        tempFillArray.append(processedImage!)
                    }
                }
            }
            downloadedImages = tempFillArray
            return tempFillArray
        }
        return []
    }
    
    var body: some View {
		ZStack {
			TabView {
				VStack(alignment: .leading) {
					Text("My View").modifier(CustomBodyFontModifier(size: 35))
						.padding(.vertical, 20).foregroundColor(.white).padding(.leading, 20).padding(.top, 40)
					ScrollView {
						VStack (alignment: .leading, spacing: 10) {
							Picker("",selection:$selectedWeek) {
								ForEach(0 ..< weeks.count ) { index in
									Text(self.weeks[index]).tag(index)
								}
							}.pickerStyle(SegmentedPickerStyle()).background(Color("bg-color")).cornerRadius(1).padding([.top, .horizontal], 20).padding(.bottom, 5)
							VStack {
								VStack(alignment: .center) {
									if image == nil {
										ZStack(alignment: .bottomTrailing) {
											Image(uiImage: loadWarpImages()[selectedWeek])
												.resizable()
												.aspectRatio(contentMode: .fill)
												.padding(.horizontal, 20)
												.padding(.vertical, 5)
															
											Button(action: {
												self.shareImage()
											}, label: {
												Image(systemName: "square.and.arrow.up").resizable().renderingMode(.template).foregroundColor(Color("primary")).aspectRatio(contentMode: .fit).padding(15)
											})
											.background(Color(.white))
											.clipShape(Circle())
											.frame(width: 55, height: 55)
											.padding(.trailing, 40)
											.padding(.bottom, 40)
											.shadow(color: Color("secondary"), radius: 5, x: 1, y: 2)
										}
									} else {
										image?.resizable()
											.aspectRatio(contentMode: .fit)
									}
								}.frame(width: screen.width - 20,height: 450, alignment: .center)
							}.padding(.vertical, 10)
							
							HStack {
								Spacer()
								ZStack {
									Color("bg-color")
										.background(Color("bg-color"))
										.clipShape(RoundedRectangle(cornerRadius: 8))
										.shadow(color: Color("secondary"), radius: 3, x: 0, y: 3)
									VStack(alignment: .leading) {
										HStack{
											Text("Weight").font(.caption).foregroundColor(Color("primary"))
											.padding(.top)
											Spacer()
										}.padding(.horizontal)
										Text(self.getWeight()).font(.body).foregroundColor(Color("secondary"))
											.padding(.bottom)
											.padding(.horizontal)
									}
								}.padding(.horizontal, 3)
								Spacer()
								ZStack {
									Color("bg-color")
										.background(Color("bg-color"))
										.clipShape(RoundedRectangle(cornerRadius: 8))
										.shadow(color: Color("secondary"), radius: 3, x: 0, y: 3)
									VStack(alignment: .leading) {
										HStack {
											Text("Waist").font(.caption).foregroundColor(Color("primary"))
												.padding(.top)
											Spacer()
										}.padding(.horizontal)
										Text(self.getWaist()).font(.body).foregroundColor(Color("secondary"))
											.padding(.bottom)
											.padding(.horizontal)
									}
								}.padding(.horizontal, 3)
								Spacer()
								ZStack {
									Color("bg-color")
										.background(Color("bg-color"))
										.clipShape(RoundedRectangle(cornerRadius: 8))
										.shadow(color: Color("secondary"), radius: 3, x: 0, y: 3)
									VStack(alignment: .leading) {
										Text("BMI").font(.caption).foregroundColor(Color("primary"))
											.padding(.top)
										HStack {
											Text("\(Int(self.getBMI()))").font(.body)
												.foregroundColor(Color("secondary"))
											Text("\(self.getLabel(for: self.getBMI()))")
												.font(.caption).foregroundColor(Color("accent-text-green"))
										}
										.padding(.bottom)
									}
								}.padding(.horizontal, 3)
								
								Spacer()
							}
							
							Spacer()
						}.padding()
					}.background(Color(.white)).clipShape(Rounded()).padding(1)
				}
				.frame(minWidth: 0, maxWidth: .infinity).background(Color("primary")).edgesIgnoringSafeArea(.top)
				.tabItem({
					Image("rsz_ic_myview")
					Text("My View")
					}).tag(0)
				
				HealthView().tabItem({
					Image(systemName: "chart.bar.fill")
					Text("My Health")
				}).tag(1)
				Update().tabItem({
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
            
            if isWellDone {
                Rectangle()
                    .fill(Color(.black))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .opacity(0.6)
                    .edgesIgnoringSafeArea([.top, .bottom])
                
                VStack (alignment: .center) {
                    HStack {
                        Spacer()
                        
                        Text("Well done!")
                            .foregroundColor(Color("primary"))
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            self.isWellDone = false
                            UserDefaults.standard.set(false, forKey: "showWellDonePop")
                        }, label: {
                            Image(systemName: "xmark")
                            .foregroundColor(Color("primary"))
                        })
                            .frame(alignment: .trailing)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                    .padding()
                                    
                    VStack {
                        Text("Your new measurements have been updated. You are now one step closer to achieve your body goal. Keep it up!")
                            .foregroundColor(Color(.black))
                        
                        Spacer()
                        
                        Image("welldone")
							.resizable()
                            .frame(width: 60, height: 60, alignment: .bottom)
                    }.padding()
                    
                    Spacer()
                    
                }.background(Color(.white))
                .frame(minWidth: 100, maxWidth: 320, minHeight: 100, maxHeight: 250)
                .cornerRadius(30)
                .opacity(0.8)
            }
        }
    }
	
	func getWeight() -> String {
		let isMetric = UserDefaults.standard.bool(forKey: "Metrics")
		var weight = UserDefaults.standard.double(forKey: "BBIWeightKey")
		
		var weightString: String
		if isMetric {
			weightString = "\(Int(weight)) Kg"
		} else {
			// TODO:- Remove when metrics are saved correctly
			weight = changeMetrics(metricType: .imperial, unit: .weight, value: weight)
			weightString = "\(Int(weight)) lb"
		}
		return weightString
	}
	
	func getWaist() -> String {
		let isMetric = UserDefaults.standard.bool(forKey: "Metrics")
		var waist = UserDefaults.standard.double(forKey: "BBIWaistKey")
		
		var waistString: String
		if isMetric {
			waistString = "\(Int(waist)) cm"
		} else {
			// TODO:- Consider removing
			// Conversion should be unecessary if original data had been
			// saved in the user selected unit system.
			waist = changeMetrics(metricType: .imperial, unit: .height, value: waist)
			waistString = "\(Double(Int(waist) * 10) / 10) ft"
		}
		print("waist: \(waistString)")
		return waistString
	}
	
	func getBMI() -> Double {
		let isMetric = UserDefaults.standard.bool(forKey: "Metrics")
		var weight = UserDefaults.standard.double(forKey: "BBIWeightKey")
		var height = UserDefaults.standard.double(forKey: "BBIHeightKey")
		
		// TODO:- Add the WEIGHT calculation below again after getting metrics saved correctly.
		if !isMetric {
			height = changeMetrics(metricType: .metric, unit: .height, value: height)
			//weight = changeMetrics(metricType: .metric, unit: .weight, value: weight)
		}
		let bmi = Int(weight / height / height  * 10_000.0)
		return Double(bmi)
	}
	
	func getLabel(for bmi: Double) -> String {
		if bmi < 18.5 { return "Underweight" }
		if bmi < 25 { return "Healthy" }
		if bmi < 30 { return "Overweight" }
		return "Obese"
	}
	
    func shareImage() {
        let shareSheet = UIActivityViewController(activityItems: [downloadedImages[0],downloadedImages[3]], applicationActivities: nil)
        shareSheet.excludedActivityTypes = [.message,.addToReadingList,.markupAsPDF,.openInIBooks,.print]
        UIApplication.shared.windows.first?.rootViewController?.present(shareSheet, animated: true, completion: nil)
    }
}

struct Rounded: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 40, height: 40))
        return Path(path.cgPath)
    }
}
