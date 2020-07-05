//
//  GifViewController.swift
//  View2Lose
//
//  Created by purich purisinsits on 1/7/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import SwiftyGif
import SwiftUI


struct GifView: UIViewRepresentable {
    let gifName: String
    @Binding var play: Bool

    func makeUIView(context: Context) -> UIImageView {
        guard let gif = try? UIImage.init(gifName: gifName) else {
            return UIImageView()
        }
        let imageView = UIImageView(gifImage: gif)
        // Use scale aspect fit here, otherwise the gif will resize badly if put in to a smaller frame.

        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ gifImageView: UIImageView, context: Context) {
        if play {
            gifImageView.startAnimatingGif()
        } else {
            gifImageView.stopAnimatingGif()
        }
    }
}
