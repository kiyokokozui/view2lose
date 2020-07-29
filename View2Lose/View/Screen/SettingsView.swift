//
//  SettingsView.swift
//  View2Lose
//
//  Created by Sagar on 1/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

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
						.foregroundColor(Color("SeparationColor"))
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
	@State private var saveImageToPhone = true
	@State private var sendPushNotifications = false
	
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
								Text("Parisa Safarzadeh")
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
									Text("Female")
								}
								.foregroundColor(Color("secondary"))
								HStack {
									Text("Height")
									Spacer()
									Text("5ft 9in")
								}
								.foregroundColor(Color("secondary"))
								HStack {
									Text("Weight")
									Spacer()
									Text("154 lbs")
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
							Toggle(isOn: $sendPushNotifications) {
								Text("Send push notifications")
								.foregroundColor(Color("secondary"))
							}
							.padding(.bottom, 16)
						}
					}
					
					Section(header: ListHeader("Support")) {
						VStack(alignment: .leading) {
							// TODO: - Replace with actual view.
							NavigationLink(destination: Text("Calling")) {
								Text("Call us")
								.foregroundColor(Color("secondary"))
							}
							
							HStack {
								Spacer()
								Text("Log out")
									.font(.body)
									.foregroundColor(Color("WarningColor"))
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
		}
	}
	
	func setNewWeightGoalTapped() {}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
