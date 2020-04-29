//
//  Modifiers.swift
//  View2Lose
//
//  Created by Sagar on 16/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct CustomHeaderFontModifier: ViewModifier {
    var size: CGFloat = 28
    func body(content: Content) -> some View {
        content.font(.custom("Montserrat-SemiBold", size: size))
    }
}

struct CustomBodyFontModifier: ViewModifier {
    var size: CGFloat = 16
    func body(content: Content) -> some View {
        content.font(.custom("Lato-Regular", size: size))
    }
}

struct CustomBoldBodyFontModifier: ViewModifier {
    var size: CGFloat = 20
    func body(content: Content) -> some View {
        content.font(.custom("Lato-Bold", size: size))
    }
}




