//
//  FrontFacingCameraView.swift
//  View2Lose
//
//  Created by Sagar on 12/5/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation
//FrontFacingCameraView
import Combine
import CoreMotion


class CameraViewModel: ObservableObject, Identifiable {
    @Published var image: Image?
    @Published var inputImage: UIImage?
    let WillChange = PassthroughSubject<Void, Never>()
    @Published var currentCamera: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                                        for: .video, position: .back)!
    @Published var didTapCapture: Bool = false
    
    var changeToFrontCamera = true {
        didSet {
            print(currentCamera)

            if changeToFrontCamera {
                if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                        for: .video, position: .back) {
                    currentCamera = device
                } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                               for: .video, position: .back) {
                    currentCamera = device
                } else {
                    fatalError("Missing expected back camera device.")
                }
            } else {
                if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                    currentCamera = frontCameraDevice
                }
                
            }
            
            WillChange.send()
        }
    }
}


struct FrontFacingCameraView: View {
    
    @State private var image: Image?
    @State private var showingCustomCamera = false
    @State private var inputImage: UIImage?
    @State var didTapCapture: Bool = false
    
    @State private var currentCamera: AVCaptureDevice?
    
    @ObservedObject var cameraViewModel = CameraViewModel()
    
    var body: some View {
            VStack {
                
                if cameraViewModel.changeToFrontCamera {
                    CustomFrontFacingCameraView(viewModel: cameraViewModel, image: self.$inputImage, currentCamera: self.$currentCamera)
                } else {
                    CustomFrontFacingCameraView(viewModel: cameraViewModel, image: self.$inputImage, currentCamera: self.$currentCamera)
                }
                
            }
        
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
   
}



struct CustomFrontFacingCameraView: View {
    
    @State var viewModel: CameraViewModel?
    @Binding var image: UIImage?
    @State var didTapCapture: Bool = false
    @State var changeToFrontCamera = true
   // @State private var levelColor: Color = Color(.red)
    @Binding var currentCamera: AVCaptureDevice?
    @State private var levelColor: Color = Color(.red)
    
    @EnvironmentObject var facebookManager: FacebookManager
//for: .video, position: .back)!)
    
    func createFrontCameraView() -> some View {
        print("ChangeToFrontCamera")

        print("Custom Create View \(viewModel!.currentCamera)")
        return CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture, viewModel: (viewModel), levelColor: self.$levelColor)

    }
    
    func createBackCameraView() -> some View {
        print("ChangeToBackCamera")

        return CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture, viewModel: (viewModel), levelColor: self.$levelColor)

    }
    
    func saveImage() {
              guard let inputImage = image else { return }

              if let imageData = inputImage.jpegData(compressionQuality: 0) {
                  let frontPath = self.getDocumentsDirectory().appendingPathComponent("com.smr.front.png")
                try? imageData.write(to: Foundation.URL(fileURLWithPath: frontPath), options: [.atomic])

              }
          }
          
          // MARK: Get Documents Directory
           
       func getDocumentsDirectory() -> NSString {
           let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
           let documentsDirectory = paths[0]
           return documentsDirectory as NSString
       }
    
    //

   
     

    
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
            }
            //else {
//                if viewModel!.changeToFrontCamera {
//                    createBackCameraView()
//
//                } else {
//
//                    createFrontCameraView()
//                }
//
//            }
            
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
                    ZStack(alignment: .center) {
                        Spacer()
                        createFrontCameraView()
                        //Image("Front-silhouette").resizable().aspectRatio(contentMode: .fit)
                        Spacer()
                    }
                    .frame(height: UIScreen.main.bounds.height  * 2/3)
                    .frame(maxWidth: .infinity)
                    //.overlay(Rectangle().stroke(levelColor, style: StrokeStyle(lineWidth: 3)))
                    
                    
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
                                                    self.facebookManager.isUserAuthenticated = .cameraOnBoard2
                                                    print("Saved Image")
                                                    
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

struct BlurView : UIViewRepresentable {
    var effect : UIBlurEffect.Style
    var alpha : CGFloat
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: effect)
        let blurview = UIVisualEffectView(effect:  blurEffect)
        blurview.alpha = alpha
        return blurview
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context:  UIViewRepresentableContext<BlurView>) {
        
    }
}


struct CustomCameraRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var didTapCapture: Bool
    //@State var currentCamera: AVCaptureDevice
    @State var viewModel: CameraViewModel?
    //@State private var levelColor: Color
    @Binding var levelColor: Color
    
    
    func makeUIViewController(context: Context) -> CustomCameraController {
        let controller = CustomCameraController()
        controller.delegate = context.coordinator
        controller.currentCamera = self.viewModel?.currentCamera
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {
        
        if(self.didTapCapture) {
            cameraViewController.didTapRecord()
        }
       // cameraViewController.levelColor = levelColor
        //self.levelColor = cameraViewController.levelColor
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentable
        
        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            parent.didTapCapture = false
            
            if let imageData = photo.fileDataRepresentation() {
                parent.image = UIImage(data: imageData)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

class CustomCameraController: UIViewController {
    
    var image: UIImage?
    
    var levelColor: UIColor = .red
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    let squareLayer = CAShapeLayer()
    //DELEGATE
    var delegate: AVCapturePhotoCaptureDelegate?
    
    
    var motionManager = CMMotionManager()
    var isVerticallyLevel = false
    var isHorizontallyLevel = false
    
    func didTapRecord() {
        
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
        //self.view.layer.borderColor = self.levelColor.cgColor
      //       self.view.layer.borderWidth = 3
        setupSquareBox()
        
        
    }
    
    func setupSquareBox() {
        squareLayer.path = UIBezierPath(roundedRect: CGRect(x: 10.0, y: 10.0, width: self.view.bounds.width - 20.0, height: self.view.bounds.height - 20.0), cornerRadius: 4.0).cgPath
        squareLayer.strokeColor = UIColor.red.cgColor
        squareLayer.fillColor = UIColor.clear.cgColor
        squareLayer.lineWidth = 2
        self.view.layer.addSublayer(squareLayer)
        
        
    }
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.view.layer.borderColor = self.levelColor.cgColor
                    self.view.layer.borderWidth = 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startLevelMotionDetection()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
    }
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    

      
      func startLevelMotionDetection()  {
          //cameraOverlay!.layer.opacity = 1.0
          
          let numberFormatter = NumberFormatter()
          numberFormatter.positiveFormat = "0.##"
          numberFormatter.negativeFormat = "0.##"
          
          // Setup & Use Accelerometer For Levels
          if motionManager.isAccelerometerAvailable {
              // Apply A Low Pass Filter To Accelerometer Data To Smooth It
              var z0: Float = 0.0
              var x0: Float = 0.0
              
              let timeInterval: Float = 0.01
              let RC: Float = 0.3
              let alpha: Float = timeInterval / (RC + timeInterval)
              
              motionManager.deviceMotionUpdateInterval = TimeInterval(timeInterval)
              if let queue = OperationQueue.current {
                  motionManager.startAccelerometerUpdates(to: queue) { [weak self] (data, error) in
                      DispatchQueue.main.async {
                          let smoothedZ = (alpha * Float(data!.acceleration.z)) + (1.0 - alpha) * z0
                          let smoothedX = (alpha * Float(data!.acceleration.x)) + (1.0 - alpha) * x0
                          //self!.cameraOverlay?.adjustVerticalLevel(value: smoothedZ)
                          //self!.cameraOverlay?.adjustHorizontalLevel(value: smoothedX)
                        self?.adjustVerticalLevel(value: smoothedZ)
                        self?.adjustHorizontalLevel(value: smoothedX)
                        print(self?.levelColor)
                          z0 = smoothedZ
                          x0 = smoothedX
                      }
                  }
              }
          }
      }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           stopLevelMotionDetection()
       }
    
    
      
      func stopLevelMotionDetection() {
          motionManager.stopAccelerometerUpdates()
      }
      
    
    // MARK: Adjust Vertical Level
    
    func adjustVerticalLevel(value: Float) {
        let updatedVerticalValue = max(1.0, min((80.0 * value) + 40.0, 79.0))
        isVerticallyLevel = updatedVerticalValue >= 30.0 && updatedVerticalValue <= 50.0
        updateBoxColor()
        
        //self.verticalLevel?.adjustIndicator(CGFloat(value))
    }
    
    // MARK: Adjust Horizontal Level
    
    func adjustHorizontalLevel(value: Float) {
        let updatedHorizontalValue = max(1.0, min((80.0 * value) + 40.0, 79.0))
        isHorizontallyLevel = updatedHorizontalValue >= 36.0 && updatedHorizontalValue <= 42.0
        updateBoxColor()
        
        //self.horizontalLevel?.adjustIndicator(CGFloat(value))
    }
    
    // MARK: Update Box Color
    
    func updateBoxColor() {
        if isCameraLevel() {
            self.levelColor = .green
            self.view.layer.borderColor = UIColor.green.cgColor
            squareLayer.strokeColor = UIColor.green.cgColor
            
        } else {
            self.levelColor =  .red
            self.view.layer.borderColor = UIColor.red.cgColor
            squareLayer.strokeColor = UIColor.red.cgColor


        }
    }

        func isCameraLevel() -> Bool {
    //        guard self.horizontalLevel != nil && self.verticalLevel != nil else {
    //            return false
    //        }
    //        return self.horizontalLevel!.isLeveled && self.verticalLevel!.isLeveled
            return isHorizontallyLevel && isVerticallyLevel
        }

    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {
            
            switch device.position {
            case AVCaptureDevice.Position.front:
                self.frontCamera = device
            case AVCaptureDevice.Position.back:
                self.backCamera = device
            default:
                break
            }
        }
        
        //self.currentCamera = self.frontCamera
    }
    
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
        } catch {
            print(error)
        }
        
    }
    func setupPreviewLayer()
    {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}


struct CaptureButtonView: View {
    @State private var animationAmount: CGFloat = 1
    var body: some View {
        
        VStack {
            Circle().frame(width: 75, height: 75).foregroundColor(Color(#colorLiteral(red: 0.7711208463, green: 0.7641481757, blue: 0.7574309707, alpha: 1))).overlay(
                Circle()
                    .stroke(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), style: StrokeStyle(lineWidth: 4))
            )
                .shadow(radius: 5, x: 1, y:3)
            //        }
        }
    }
}

struct UsePictureButton: View {
    var body: some View {
        
        VStack {
            Image(systemName: "suit.heart")
                .resizable().frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
                .padding(25).background(Color(#colorLiteral(red: 0.589797318, green: 0.4313705266, blue: 0.9223902822, alpha: 1))).clipShape(Circle())
                
                .overlay(
                    //
                    Circle()                    .stroke(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), style: StrokeStyle(lineWidth: 4))
            )
            //                .shadow(radius: 5, x: 1, y:3))
            //        }
        }
    }
}


struct FrontFacingCameraView_Previews: PreviewProvider {
    static var previews: some View {
        FrontFacingCameraView()
    }
}
