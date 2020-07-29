//
//  FrontFacingCameraView.swift
//  View2Lose
//
//  Created by Sagar on 11/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation
//FrontFacingCameraView
import Combine
import CoreMotion

struct FrontFacingCameraView: View {
    
   @State private var image: Image?
   @State private var showingCustomCamera = false
   @State private var inputImage: UIImage?
   @State var didTapCapture: Bool = false
   @State private var currentCamera: AVCaptureDevice?
   @ObservedObject var cameraViewModel = CameraViewModel()
 
       var body: some View {
               VStack {
                   
                CustomFrontFacingCameraView(viewModel: cameraViewModel, image: self.$inputImage, currentCamera: self.$currentCamera, overlayView: FrontCameraOverlay(), sideImage: false)
                   }
        }
}

struct SideFacingCameraView: View {
    
    @State private var image: Image?
       @State private var showingCustomCamera = false
       @State private var inputImage: UIImage?
       @State var didTapCapture: Bool = false
       
       @State private var currentCamera: AVCaptureDevice?
       
      @ObservedObject var cameraViewModel = CameraViewModel()
       
       var body: some View {
               VStack {
                   
                CustomSideFacingCameraView(viewModel: cameraViewModel, image: self.$inputImage, currentCamera: self.$currentCamera, overlayView: SideCameraOverlay(), sideImage: true)
                }
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
    @State var overlayView: UIView
    @State var sideImage : Bool
    
    @EnvironmentObject var facebookManager: FacebookManager
//for: .video, position: .back)!)
    
    func createFrontCameraView() -> some View {
          print("ChangeToFrontCamera")

          print("Custom Create View \(viewModel!.currentCamera)")
          return CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture, viewModel: (viewModel), levelColor: self.$levelColor)

    }
      
    
    var body: some View {
        VStack {
            
            ZStack {
                
                CustomImagePicker(sourceType: .camera, overlayView: overlayView, sideImage: sideImage) { (image) in
                    print("Print Image")
                }.onReceive(CameraPicker.shared.$image) { (image) in
                   
                        if let image = image {
                            print("Side Image: \(self.sideImage)")
                            if !self.sideImage {
                                //CameraPicker.shared.image = nil
                                self.facebookManager.isUserAuthenticated = .cameraOnBoard2
                                 CameraPicker.shared.image = nil
                               self.sideImage = true
                            }
                         self.sideImage = true
                           

                        }
                    
                    
                }
                
               // Image("Front-silhouette").resizable().aspectRatio(contentMode: .fit)

                
            }
            
            
        } .edgesIgnoringSafeArea(.all)
    }

}

struct CustomSideFacingCameraView: View {
    
    @State var viewModel: CameraViewModel?
    @Binding var image: UIImage?
    @State var didTapCapture: Bool = false
    @State var changeToFrontCamera = true
   // @State private var levelColor: Color = Color(.red)
    @Binding var currentCamera: AVCaptureDevice?
    @State private var levelColor: Color = Color(.red)
    @State var overlayView: UIView
    @State var sideImage : Bool
    
    @EnvironmentObject var facebookManager: FacebookManager
//for: .video, position: .back)!)
    
    func createFrontCameraView() -> some View {
          print("ChangeToFrontCamera")

          print("Custom Create View \(viewModel!.currentCamera)")
          return CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture, viewModel: (viewModel), levelColor: self.$levelColor)

    }
      
    
    var body: some View {
        VStack {
            
            ZStack {
                
                CustomImagePicker(sourceType: .camera, overlayView: overlayView, sideImage: sideImage) { (image) in
                    print("Print Image")
                }.onReceive(CameraPicker.shared.$image) { (image) in
                    
                    if let image = image {
                        print("Image Size: \(image)")
                        CameraPicker.shared.image = nil
                        if self.sideImage {
                            self.facebookManager.isUserAuthenticated = .imagePreview
                        }
                        

                    }
                    
                }
                
               // Image("Front-silhouette").resizable().aspectRatio(contentMode: .fit)

                
            }
            
            
        } .edgesIgnoringSafeArea(.all)
    }

}


struct CustomImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return CameraPicker.shared.coordinator

    }
    
  
    @ObservedObject var cameraViewModel = Camera1ViewModel()

    
    typealias UIViewControllerType = ImagePickerViewController
    
    
    @Environment(\.presentationMode) var presentationMode

      // @Binding var image: UIImage?
//@Binding var didTapCapture: Bool
       //@State var currentCamera: AVCaptureDevice
       //@State var viewModel: CameraViewModel?
       //@State private var levelColor: Color
     //  @Binding var levelColor: Color
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    let overlayView: UIView
    let sideImage: Bool
    init(sourceType: UIImagePickerController.SourceType, overlayView: UIView, sideImage: Bool, onImagePicked: @escaping (UIImage) -> Void) {
              self.sourceType = sourceType
              self.onImagePicked = onImagePicked
            self.overlayView = overlayView
        self.sideImage = sideImage
    }
    
    
    func makeUIViewController(context: Context) -> ImagePickerViewController {
          let controller = ImagePickerViewController()
        controller.sourceType = sourceType
        controller.cameraViewModel = self.cameraViewModel
        controller.showsCameraControls = false
        controller.delegate = context.coordinator
        controller.sidePhoto = self.sideImage
        
        controller.overlayView = self.overlayView
        return controller
    }
    
      
      func updateUIViewController(_ uiViewController: ImagePickerViewController, context: Context) {
        //print("Update: \(String(describing: uiViewController.cameraOverlay!.squareLayer.strokeColor!))")
      }
    
 
}

extension CustomImagePicker {

     class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

         func didChangeValue<Value>(for keyPath: KeyPath<ImagePicker.Coordinator, Value>) {
             
         }
         
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
             CameraPicker.shared.image = Image(uiImage: image)
            print("Image Picked: \(image.size)")
            if let picker = picker as? ImagePickerViewController {
                if picker.sidePhoto! {
                    print("Side Photo")
                    if let sideData = image.jpegData(compressionQuality: 0) {
                        let sidePath = self.getDocumentsDirectory().appendingPathComponent("com.smr.side.png")
                        try? sideData.write(to: NSURL(fileURLWithPath: sidePath) as URL, options: [.atomic])
                    }
                } else {
                    print("Front Photo")
                    if let frontData = image.jpegData(compressionQuality: 0) {
                        let frontPath = self.getDocumentsDirectory().appendingPathComponent("com.smr.front.png")
                        try? frontData.write(to: NSURL(fileURLWithPath: frontPath) as URL, options: [.atomic])
                    }
                }
            }
            
            // picker.dismiss(animated: true, completion: nil)

        }
        
        func getDocumentsDirectory() -> NSString {
              let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
              let documentsDirectory = paths[0]
              return documentsDirectory as NSString
          }
    }
        
      
 }


class CameraPicker: ObservableObject {
    static let shared: CameraPicker = CameraPicker()
    private init() {}
    
    let view = ImagePicker.View()
    let coordinator = CustomImagePicker.Coordinator()
    
    let willChange = PassthroughSubject<Image?, Never>()
    @Published var image:Image? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }
    
}
@objc protocol ImagePickerControllerDelegateExtension: class {
    func photosComplete()
}


class ImagePickerViewController: UIImagePickerController {
    var overlayImage : UIImage?

    var flashON = true
    var flashBtn: UIButton?
    var voiceBtn: UIButton?
    var frontBackToggleBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    var capturePictureBtn: UIButton?
    var captureCancelBtn: UIButton?
    var overlayView: UIView?
   var cameraOverlay: UIView?
    var bodyPhotos: BodyImages?
    var preCapturePlayer: AVQueuePlayer?
    var capturePlayer: AVPlayer?
    var sideCapturePlayer: AVPlayer?
    var countdownLabel: UILabel?
    var countdownObserver: Any?
    var retakingPhoto: Bool = false
    var sidePhoto: Bool?
    var motionManager = CMMotionManager()
    var cameraViewModel: Camera1ViewModel?
    var isVerticallyLevel = false
       var isHorizontallyLevel = false
    
    @objc weak var ipDelegate: ImagePickerControllerDelegateExtension?

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startLevelMotionDetection()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopLevelMotionDetection()
        
    }
    
    
    let squareLayer = CAShapeLayer()
    
    var topLabel: UILabel = {
          let label = UILabel()
          label.text = "FRONT VIEW"
          label.translatesAutoresizingMaskIntoConstraints = false
          label.textColor = .white
          return label
      }()
    
    var sideLabel: UILabel = {
        let label = UILabel()
        label.text = "SIDE VIEW"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
      
      var photoLabel: UILabel = {
          let photoLabel = UILabel()
          photoLabel.text = "PHOTO"
          photoLabel.translatesAutoresizingMaskIntoConstraints = false
          photoLabel.textColor = #colorLiteral(red: 0.9408810735, green: 0.753742516, blue: 0.001838603755, alpha: 1)
        photoLabel.font = UIFont.systemFont(ofSize: 14)
          return photoLabel
      }()
      

    override func viewDidLoad() {
//cameraOverlay = CameraOverlay()
        super.viewDidLoad()
     
        
        
    }
    
    @objc func capturePicture() {
        if self.isCameraLevel() {
            self.takePicture()

        }
    }
    
    @objc func toggleCamera() {
        
    }
    
    func uiInit(){
           cameraOverlay = overlayView
                self.cameraOverlayView = overlayView
                let cameraControlsCenter = capturePictureBtn?.center ?? .zero

                
                let screenSize = UIScreen.main.bounds.size
                              let cameraAspectRatio = CGFloat(4.0/3.0)
                              let imageHeight = screenSize.width * cameraAspectRatio
                squareLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 44, width: self.view.bounds.width, height: imageHeight), cornerRadius: 4.0).cgPath
                squareLayer.strokeColor = UIColor.yellow.cgColor
                
                squareLayer.fillColor = UIColor.clear.cgColor
                squareLayer.lineWidth = 2
                self.view.layer.addSublayer(squareLayer)
                
                self.view.addSubview(topLabel)
                topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                topLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
                
                
                
                
                self.view.addSubview(sideLabel)
               sideLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
               sideLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
                
                if self.sidePhoto! {
                    sideLabel.isHidden = false
                    topLabel.isHidden = true
                } else {
                    sideLabel.isHidden = true
                    topLabel.isHidden = false
                }
                
                // Move Camera Preview Down Below Controls If Needed
                let screenSize1 = UIScreen.main.bounds.size
                self.cameraViewTransform = CGAffineTransform(translationX: 0.0, y: 44.0);
                

                
                // Add Camera Capture Btn
                let cameraViewFrame = cameraOverlay?.frame ?? .zero
                let imageViewYBottom = cameraViewFrame.size.height + cameraViewFrame.origin.y
                let buttonY = ((screenSize1.height - imageViewYBottom) / 2.0) - 35.0 + imageViewYBottom
                capturePictureBtn = UIButton(frame: CGRect(x: (screenSize1.width / 2.0) - 35.0,
                    y: buttonY,
                    width: 70.0,
                    height: 70.0))
                
                // Set Button States
                capturePictureBtn!.setImage(UIImage(named: "CaptureBtnUp"), for: UIControl.State())
                capturePictureBtn!.setImage(UIImage(named: "CaptureBtnDown"), for: UIControl.State.highlighted)
                capturePictureBtn!.addTarget(self, action: #selector(capturePicture), for: .touchDown)
               // capturePictureBtn!.layer.opacity = 0
                self.view.addSubview(capturePictureBtn!)
                self.view.addSubview(frontBackToggleBtn)
                
                self.view.addSubview(photoLabel)
                photoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                photoLabel.bottomAnchor.constraint(equalTo: capturePictureBtn!.topAnchor, constant: -10).isActive = true

                frontBackToggleBtn.backgroundColor = UIColor.clear
                frontBackToggleBtn.setImage(UIImage(named: "camera_toggle"), for: .normal)
                frontBackToggleBtn.addTarget(self, action: #selector(toggleCamera), for: .touchDown)
                // Add Font/Back Camera Btn
                //frontBackToggleBtn = UIButton(frame: CGRect(x: screenSize1.width - 54.0,
        //                                                    y: cameraControlsCenter.y + imageViewYBottom,
        //                                                    width: 44.0,
        //                                                    height: 44.0))
                frontBackToggleBtn.translatesAutoresizingMaskIntoConstraints = false
                frontBackToggleBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
                frontBackToggleBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -41).isActive = true
                frontBackToggleBtn.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
                frontBackToggleBtn.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
                
                
                // Add Selfie Countdown Label Under Capture Btn
                countdownLabel = UILabel(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: 70.0,
                                                       height: 70.0))
                countdownLabel?.center = cameraControlsCenter
                countdownLabel?.backgroundColor = UIColor.clear
                countdownLabel?.font = UIFont.boldSystemFont(ofSize: 55)
                countdownLabel?.textColor = UIColor.white
                countdownLabel?.textAlignment = .center
                countdownLabel?.isHidden = true
                self.view.addSubview(countdownLabel!)
        
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
                           // self!.cameraOverlay?.adjustVerticalLevel(value: smoothedZ)
                           // self!.cameraOverlay?.adjustHorizontalLevel(value: smoothedX)
                         self?.adjustVerticalLevel(value: smoothedZ)
                         self?.adjustHorizontalLevel(value: smoothedX)
                        // print(smoothedX)
                           z0 = smoothedZ
                           x0 = smoothedX
                       }
                   }
               }
           }
       }
    
    func adjustVerticalLevel(value: Float) {
         let updatedVerticalValue = max(1.0, min((80.0 * value) + 40.0, 79.0))
         isVerticallyLevel = updatedVerticalValue >= 30.0 && updatedVerticalValue <= 50.0
       // print(updatedVerticalValue)
         updateBoxColor()
         //print(isVerticallyLevel)
         //self.squareBox.layer.borderColor = UIColor.green.cgColor

         
         //self.verticalLevel?.adjustIndicator(CGFloat(value))
     }
     
     // MARK: Adjust Horizontal Level
     
     func adjustHorizontalLevel(value: Float) {
         let updatedHorizontalValue = max(1.0, min((80.0 * value) + 40.0, 79.0))
         isHorizontallyLevel = updatedHorizontalValue >= 36.0 && updatedHorizontalValue <= 42.0
       // print(updatedHorizontalValue)
         updateBoxColor()
         //print(isHorizontallyLevel)
         //self.layoutIfNeeded()

         
         //self.horizontalLevel?.adjustIndicator(CGFloat(value))
     }
     
    
     
     // MARK: Update Box Color
     
     
     func updateBoxColor() {
         if isCameraLevel() {
            self.squareLayer.strokeColor = UIColor.green.cgColor
            self.capturePictureBtn?.isUserInteractionEnabled = true
            self.capturePictureBtn?.layer.opacity = 1

         } else {
            self.squareLayer.strokeColor = UIColor.red.cgColor
            self.capturePictureBtn?.isUserInteractionEnabled = false
            self.capturePictureBtn?.layer.opacity = 0.7
        }
        
    }
    
    func isCameraLevel() -> Bool {
        return isHorizontallyLevel && isVerticallyLevel
    }
    
       
       func stopLevelMotionDetection() {
                motionManager.stopAccelerometerUpdates()
        }
       

    
        
}

class FrontCameraOverlay: UIView  {
    var isVerticallyLevel = false
    var isHorizontallyLevel = false
    var cameraViewModel: Camera1ViewModel?
    

    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"Front-silhouette")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
        }()
    
    let squareBox: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 3
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var squareLayer = CAShapeLayer()
    static let onChangeColorNotification = "onChangeColorNotification"

    
    convenience init() {
        let screenSize = UIScreen.main.bounds.size
               let cameraAspectRatio = CGFloat(4.0/3.0)
               let imageHeight = screenSize.width * cameraAspectRatio

               self.init(frame: CGRect(x: 0.0,
                                       y: 44.0,
                                       width: screenSize.width,
                                       height: imageHeight))
        


        addSubview(imageView)

        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true

        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true


    }



 
}


class SideCameraOverlay: UIView  {
    var isVerticallyLevel = false
    var isHorizontallyLevel = false
    var cameraViewModel: Camera1ViewModel?
    

    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"Side-Silhouette")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
        }()
    
    let squareBox: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 3
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var squareLayer = CAShapeLayer()
    static let onChangeColorNotification = "onChangeColorNotification"

    
    convenience init() {
        let screenSize = UIScreen.main.bounds.size
               let cameraAspectRatio = CGFloat(4.0/3.0)
               let imageHeight = screenSize.width * cameraAspectRatio

               self.init(frame: CGRect(x: 0.0,
                                       y: 44.0,
                                       width: screenSize.width,
                                       height: imageHeight))
        


        addSubview(imageView)

        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true

        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true

    }



 

    @objc func onChangeBoxColor() {
        
    }
}

extension UIView {
    func removeShapelayer() {
        guard let idx = layer.sublayers?.firstIndex(where: { $0 is CAShapeLayer }) else { return }
        layer.sublayers?.remove(at: idx)
    }
}
class Camera1ViewModel: ObservableObject, Identifiable {

    let WillChange = PassthroughSubject<Void, Never>()// @Published var currentCamera: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                //                                                        for: .video, position: .back)!
   // @Published var didTapCapture: Bool = false
    var isLevel: Bool = false {
        didSet {
            if isLevel {
                self.boxColor = UIColor.green.cgColor
                print("Box Color: ----- \(self.boxColor)")
            } else {
                self.boxColor = UIColor.red.cgColor
                print("Box Color: ----- \(self.boxColor)")

            }
            WillChange.send()
        }
    }
    @Published var boxColor: CGColor = UIColor.green.cgColor
    
}


struct FrontFacingCameraView_Previews: PreviewProvider {
    static var previews: some View {
        FrontFacingCameraView()
    }
}
