//
//  ImagePicker.swift
//  View2Lose
//
//  Created by Sagar on 14/4/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import Combine

class ImagePicker: ObservableObject {
    static let shared: ImagePicker = ImagePicker()
    private init() {}
    
    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()
    
    let willChange = PassthroughSubject<Image?, Never>()
    @Published var image:Image? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }
    
}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        func didChangeValue<Value>(for keyPath: KeyPath<ImagePicker.Coordinator, Value>) {
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            ImagePicker.shared.image = Image(uiImage: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension ImagePicker {
    struct View: UIViewControllerRepresentable {
        func makeCoordinator() -> Coordinator {
            return ImagePicker.shared.coordinator
        }
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = context.coordinator
            return imagePickerController
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
            
        }
        
        
        
    }
}
