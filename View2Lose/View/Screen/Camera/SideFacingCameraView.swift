//
//  SideFacingCameraView.swift
//  View2Lose
//
//  Created by Sagar on 12/5/20.
//  Copyright © 2020 Sagar. All rights reserved.
// SideFacingCameraView

import SwiftUI
import Combine
import AVFoundation


struct SideFacingCameraView: View {
    
    @State private var image: Image?
    @State private var showingCustomCamera = false
    @State private var inputImage: UIImage?
    @State var didTapCapture: Bool = false
    
    @State private var currentCamera: AVCaptureDevice?
    
    @ObservedObject var cameraViewModel = CameraViewModel()
    
    var body: some View {
        
        VStack {
            
            if cameraViewModel.changeToFrontCamera {
                CustomSideFacingCameraView(viewModel: cameraViewModel, image: self.$inputImage, currentCamera: self.$currentCamera)
            } else {
                CustomSideFacingCameraView(viewModel: cameraViewModel, image: self.$inputImage, currentCamera: self.$currentCamera)
            }
            
            
            
            
            //                ZStack {
            //                    Rectangle().fill(Color.secondary)
            //
            //                    if image != nil
            //                    {
            //                        image?
            //                            .resizable()
            //                            .aspectRatio(contentMode: .fill)
            //                    }
            //                    else
            //                    {
            //                        Text("Take Photo").foregroundColor(.white).font(.headline)
            //                    }
            //                }
            //                .onTapGesture {
            //                    self.showingCustomCamera = true
            //                }
        } .edgesIgnoringSafeArea(.all)
        
        
        
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}



struct CustomSideFacingCameraView: View {
    
    @State var viewModel: CameraViewModel?
    @Binding var image: UIImage?
    @State var didTapCapture: Bool = false
    @State var changeToFrontCamera = true
    @State private var levelColor: Color = Color(.red)
    @Binding var currentCamera: AVCaptureDevice?
    
    @EnvironmentObject var facebookManager: FacebookManager
//for: .video, position: .back)!)
    
    func createFrontCameraView() -> some View {
        print("ChangeToFrontCamera")

        print("Custom Create View \(viewModel!.currentCamera)")
        return CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture, viewModel: (viewModel), levelColor: $levelColor)

    }
    
    func createBackCameraView() -> some View {
        print("ChangeToBackCamera")

        return CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture, viewModel: (viewModel), levelColor: $levelColor)

    }
    
    func saveImage() {
                 guard let inputImage = image else { return }

                 if let imageData = inputImage.jpegData(compressionQuality: 0) {
                     let frontPath = self.getDocumentsDirectory().appendingPathComponent("com.smr.side.png")
                    try? imageData.write(to: Foundation.URL(fileURLWithPath: frontPath), options: [.atomic])

                 }
             }
             
             // MARK: Get Documents Directory
              
          func getDocumentsDirectory() -> NSString {
              let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
              let documentsDirectory = paths[0]
              return documentsDirectory as NSString
          }
    
//    func toggleCamera() {
//        if changeToFrontCamera {
//            if let device = AVCaptureDevice.default(.builtInDualCamera,
//                                                    for: .video, position: .back) {
//                currentCamera = device
//
//            } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                           for: .video, position: .back) {
//                currentCamera = device
//            } else {
//                fatalError("Missing expected back camera device.")
//            }
//        } else {
//            if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
//                currentCamera = frontCameraDevice
//            }
//        }
//    }
    
    var body: some View {
        //        ZStack (alignment: .myAlignment){
        ZStack {
            //            if image != nil {
            //
            //                Image(uiImage: image!).resizable().aspectRatio(contentMode: .fit)
            //            }
            //            else
            //            {
            //                CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture)
            //            }
            
            if image != nil {
                VStack {
                    Image(uiImage: image!).resizable().aspectRatio(2.14/3, contentMode: .fit)
                    
                }
            } else {
                if viewModel!.changeToFrontCamera {
                    createBackCameraView()

                } else {

                    createFrontCameraView()
                }
                
            }
            
            VStack {
                GeometryReader  { geometry in
                    HStack(alignment: .center) {
                        
                        ZStack {
                            if self.image != nil {
                                BlurView(effect: .dark, alpha:  1).frame(width: geometry.size.width, height: geometry.size.height)
                            } else {
                                BlurView(effect: .dark, alpha:  0.8).frame(width: geometry.size.width, height: geometry.size.height)
                            }
                            
                            HStack(alignment: .center)  {
                                Button(action: {
                                    self.image = nil
                                }) {
                                    HStack(alignment: .center, spacing: 5) {
                                        Image(systemName: "camera").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color.white).frame(width: 18, height: 18)
                                        Text("Retake").foregroundColor(.white).font(.system(size: 13))
                                        
                                    }.padding(.vertical, 6).padding(.horizontal, 12).background(Color(#colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1))).cornerRadius(33)
                                    
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                //  .padding(.vertical, 2)
                                
                                
                                Spacer()
                                
                                Button(action: {
                                }) {
                                    HStack(alignment: .center, spacing: 15) {
                                        Image(systemName: "bolt.slash.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color.white).frame(width: 30, height: 30)
                                        Image(systemName: "gobackward.10").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color.white).frame(width: 30, height: 30)
                                        
                                        
                                    }
                                }.padding(.horizontal, 8)
                                //.padding(.vertical, 2)
                            }.padding(.top, 10)
                            
                            
                        }
                        
                        
                    }
                    
                }
                .edgesIgnoringSafeArea(.all)
                
                if image != nil {
                    Rectangle().fill(Color.clear).overlay(Rectangle().stroke(Color.clear, style: StrokeStyle(lineWidth: 3)))
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.width  * 4/3)
                        .padding(.top, -6)
                    
                } else {
                    VStack {
                        Spacer()
                        Image("Side-Silhouette").resizable().aspectRatio(contentMode: .fit)
                        Spacer()
                    }
                    .frame(height: UIScreen.main.bounds.height  * 2/3)
                    .frame(maxWidth: .infinity)
                    .overlay(Rectangle().stroke(Color(#colorLiteral(red: 0, green: 0.9779364467, blue: 0.2760845423, alpha: 1)), style: StrokeStyle(lineWidth: 3)))
                    
                    
                }
                
                HStack (alignment: .center) {
                    
                    
                    GeometryReader  { geometry in
                        HStack(alignment: .center) {
                            
                            ZStack {
                                if self.image != nil {
                                    BlurView(effect: .dark, alpha:  1).frame(width: geometry.size.width, height: geometry.size.height)
                                } else {
                                    BlurView(effect: .dark, alpha:  0.8).frame(width: geometry.size.width, height: geometry.size.height)
                                }
                                HStack(alignment: .center)  {
                                    Rectangle().frame(width: 50, height: 50).cornerRadius(4).overlay(Rectangle().stroke(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), style: StrokeStyle(lineWidth: 2)))
                                    Spacer()
                                    
                                    if self.image != nil {
                                        
                                            
                                            
                                                UsePictureButton().padding(.bottom, 30) .onTapGesture {
                                                    self.saveImage()
                                                    print("Image Saved!")
                                                    self.facebookManager.isUserAuthenticated = .frontBodyMeasurement

                                                }
                                  
                                        
                                    } else {
                                        CaptureButtonView().padding(.bottom, 30).onTapGesture {
                                            self.didTapCapture = true
                                            print("Tapped")
                                        }
                                    }
                                    
                                    Spacer()
                                    Button(action: {
                                        self.viewModel?.changeToFrontCamera.toggle()
                                        //print("Rotate Button Changed")
                                        //print(self.viewModel?.changeToFrontCamera ?? false)
                                    }) {
                                        Image(systemName: "camera.rotate").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color.white).frame(width: 30, height: 30)
                                    }
                                    
                                    
                                    
                                    
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                
                                
                            }
                            
                        }
                    }
                }
            }
        }
        .background(Color.black)
    }
    
}


struct SideFacingCameraView_Previews: PreviewProvider {
    static var previews: some View {
        SideFacingCameraView()
    }
}
