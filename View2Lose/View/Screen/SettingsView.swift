//
//  SettingsView.swift
//  View2Lose
//
//  Created by Sagar on 1/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import KeychainSwift

struct ListHeader: View {
	let headerTitle: String
	
	init(_ headerTitle: String)
	{ self.headerTitle = headerTitle }
	
	var body: some View {
		GeometryReader { geo in
			VStack {
				HStack {
					Text(self.headerTitle)
						.font(.body)
						.foregroundColor(Color("accent-text-green"))
						.padding(.horizontal)
					
					Spacer()
				}
				.background(Color.white)
				.listRowInsets(EdgeInsets(
					top: 0,
					leading: 0,
					bottom: 0,
					trailing: 0))
				Color("tertiary").frame(width: geo.size.width - 35, height: 1)
				Spacer()
			}
			.background(Color.white)
		}
		.listRowInsets(EdgeInsets(
			top: 0,
			leading: 0,
			bottom: 0,
			trailing: 0))
	}
}

struct SettingsView: View {
	@State private var saveImageToPhone = true {
		didSet {
			let encoder = JSONEncoder()
			if let encoded = try? encoder.encode(saveImageToPhone) {
				UserDefaults.standard.set(encoded, forKey: "BBISaveImageToPhoneKey")
			}
		}
	}
	@State private var sendPushNotifications = false {
		didSet {
			let encoder = JSONEncoder()
			if let encoded = try? encoder.encode(sendPushNotifications) {
				UserDefaults.standard.set(encoded, forKey: "BBISendPushNotificationsKey")
			}
		}
	}
	
	@State private var name = ""
	@State private var gender = ""
	@State private var height = "0.0"
	@State private var weight = "0.0"
	
	init() {
		UISwitch.appearance().onTintColor = UIColor(named: "primary")
	}
	
    var body: some View {
		NavigationView {
			VStack(alignment: .leading) {
				Text("Settings")
					.modifier(CustomBodyFontModifier(size: 35))
					.padding(.vertical, 20)
					.foregroundColor(.white)
					.padding(.leading, 20)
					.padding(.top, 20)
				
				List {
					VStack(alignment: .leading, spacing: 30) {
						HStack(alignment: .top) {
							Image(systemName: "person")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.background(Color.yellow)
								.frame(width: 70, height: 70)
								.clipShape(Circle())
								.padding()
							VStack {
								Text(self.name)
									.font(.body)
									.foregroundColor(Color("primary"))
									.padding(.top)
								Text("Sydney, Australia")
									.font(.body)
									.foregroundColor(Color("secondary"))
									.padding(.top, 9)
							}
							.padding(.trailing)
							Spacer()
						}
						.padding(.vertical)
					}
					
					Section(header: ListHeader("About you")) {
						VStack(alignment: .leading, spacing: 16) {
							VStack(alignment: .center, spacing: 16) {
								Button(action: setNewWeightGoalTapped) {
									Text("Set New Weight Goal")
										.frame(width: 226, height: 36)
										.background(Color("primary"))
										.foregroundColor(Color("white"))
										.clipShape(Capsule())
								}
								.buttonStyle(PlainButtonStyle())
								.padding(.bottom, 1)
								.padding(.top, 10)
								HStack {
									Text("Gender")
									Spacer()
									// TODO: - replace with picker
									Text(self.gender)
								}
								.foregroundColor(Color("secondary"))
								HStack {
									Text("Height")
									Spacer()
									// TODO: - replace with picker
									Text(self.height) // "5ft 8in"
								}
								.foregroundColor(Color("secondary"))
								HStack {
									Text("Weight")
									Spacer()
									// TODO: - replace with picker
									Text(self.weight) //"154 lbs"
								}
								.foregroundColor(Color("secondary"))
							}
						}
						.frame(maxWidth: .infinity)
						.padding(.bottom)
					}
					
					Section(header: ListHeader("Account")) {
						VStack(alignment: .leading, spacing: 16) {
							Toggle(isOn: $saveImageToPhone) {
								Text("Save image to phone")
								.foregroundColor(Color("secondary"))
							}
							.padding(.top, 8)
							Toggle(isOn: $sendPushNotifications) {
								Text("Send push notifications")
								.foregroundColor(Color("secondary"))
							}
							.padding(.bottom, 16)
						}
					}
					
					Section(header: ListHeader("Support")) {
						VStack(alignment: .leading) {
							Text("Call us")
							.foregroundColor(Color("secondary"))
							
							HStack {
								Spacer()
								Button("Log out", action: logOutTapped)
									.font(.body)
									.foregroundColor(Color("accent-text-red"))
									.padding(.bottom)
								Spacer()
							}
							.padding(.top)
						}
					}
				}
				.background(Color(.white))
				.clipShape(Rounded())
			}
			.frame(minWidth: 0, maxWidth: .infinity)
			.background(Color("primary"))
			.edgesIgnoringSafeArea(.top)
			.onAppear(perform: initializeData)
		}
	}
	
	func initializeData()
	{
		let keychain = KeychainSwift()
		
		if let fName: String = keychain.get("BBIFirstNameKey") {
			let lName: String = keychain.get("BBILastNameKey") ?? ""
			name = "\(fName) \(lName)"
		} else {
			name = "Name Unknown"
		}
		if let data = UserDefaults.standard.string(forKey: "BBIGenderKey") {
			gender = data == "M" ? "Male" : "Female"
			print("Gender: \(data)")
		} else {
			gender = "Unknown"
		}
		if let data = UserDefaults.standard.string(forKey: "BBIHeightKey") {
			height = data
			print("Height: \(data)")
		} else {
			height = "Unknown"
		}
		if let data = UserDefaults.standard.string(forKey: "BBIWeightKey") {
			weight = data
			print("Weight: \(data)")
		} else {
			weight = "Unknown"
		}
		if let data = UserDefaults.standard.data(forKey: "BBISaveImageToPhoneKey") {
			let decoder = JSONDecoder()
			if let decoded = try? decoder.decode(Bool.self, from: data) {
				saveImageToPhone = decoded
			}
		}
		if let data = UserDefaults.standard.data(forKey: "BBISendPushNotificationsKey") {
			let decoder = JSONDecoder()
			if let decoded = try? decoder.decode(Bool.self, from: data) {
				sendPushNotifications = decoded
			}
		}
	}
	
	func setNewWeightGoalTapped() {}
	
	func logOutTapped() {
		UserDefaults.standard.removeObject(forKey: "BBIFirstNameKey")
		UserDefaults.standard.removeObject(forKey: "BBILastNameKey")
		UserDefaults.standard.removeObject(forKey: "BBIFullNameKey")
		UserDefaults.standard.removeObject(forKey: "BBIEmailKey")
		UserDefaults.standard.removeObject(forKey: "BBIGenderKey")
		UserDefaults.standard.removeObject(forKey: "BBIHeightKey")
		UserDefaults.standard.removeObject(forKey: "BBIWeightKey")
		UserDefaults.standard.removeObject(forKey: "BBIAgeKey")
		UserDefaults.standard.removeObject(forKey: "BBIBodyTypeKey")
		UserDefaults.standard.removeObject(forKey: "BBIUserGoalKey")
		UserDefaults.standard.removeObject(forKey: "BBIActivityKey")
		UserDefaults.standard.removeObject(forKey: "BBISaveImageToPhoneKey")
		UserDefaults.standard.removeObject(forKey: "BBISendPushNotificationsKey")
		
		KeychainSwift().clear()
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
