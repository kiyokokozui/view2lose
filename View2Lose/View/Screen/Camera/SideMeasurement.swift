//
//  SideMeasurement.swift
//  View2Lose
//
//  Created by Sagar on 25/5/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import SwiftUI

struct SideMeasurement: View {
    
    //    @State private var image : UIImage?
    //    @ObservedObject var inputImage = ImageFromDirectory()
    //    @State private var imageName = "com.smr.side.png"
    //    var body: some View {
    //            VStack(alignment:.leading) {
    //                MainView(imageName: imageName).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * (3.5/4))
    //                Spacer()
    //            }.background(Color(.black))
    //                .navigationBarItems(trailing: Button(action: {}, label: {Text("Done").foregroundColor(Color(.black))}))
    //                .navigationBarTitle(Text("Side"), displayMode: .inline)
    //
    //    }
    
    let currentMeasurement = Measurements()
    
    @ObservedObject var measurmentVM =  MeasurementViewModel()
    
    @State private var image : UIImage?
    @ObservedObject var inputImage = ImageFromDirectory()
    @State private var imageName = "com.smr.side.png"
    @EnvironmentObject var facebookManager: FacebookManager
    var sideMainViewController = SideMainViewController()
    
    var body: some View {
        VStack(alignment:.leading) {
            
            sideMainViewController
            VStack {
                Button(action: {
                    self.facebookManager.isUserAuthenticated = .postOnBoardLoading
                    self.sideMainViewController.calculateSize {
                        //HAVE TO FIX THIS
                        self.facebookManager.isUserAuthenticated = .signedIn
                        print("Completed")
                    }
//                    self.facebookManager.isUserAuthenticated = .signedIn
                }, label: {
                    Text("Create").modifier(CustomBoldBodyFontModifier(size: 20))
                }).padding(.top, 20).padding(.bottom, 20).foregroundColor(.white)
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("primary"))
                    .cornerRadius(30)
                    .padding().shadow(color: Color(#colorLiteral(red: 0.8680125475, green: 0.8301205635, blue: 0.9628856778, alpha: 1)),radius: 5, x: 0, y: 6)
            }.background(Color(.white)).frame(minWidth: 0, maxWidth: .infinity)
            
        }.background(Color(.white)).edgesIgnoringSafeArea(.all)
        //                .navigationBarItems(trailing:
        //                    NavigationLink(destination: SideMeasurement()) {
        //                       // Button("Done").foregroundColor(Color(.black))
        //                        Button(action: {
        //                            print("Current VM: \(self.measurmentVM.currentMeasurments.frontRightY)")
        //                        }, label: {
        //                            Text("Done").foregroundColor(Color(.black))
        //                        })
        //                    }).navigationBarTitle(Text("Front"), displayMode: .inline)
        
        //        }
    }
}

struct SideMeasurement_Previews: PreviewProvider {
    
    static var previews: some View {
        FrontSideMeasurement()
    }
    
}

struct SideMainViewController: UIViewControllerRepresentable {
    public typealias UIViewControllerType = SideViewController
    var currentApproximation: CGFloat = 0.0
    let sideviewController = SideViewController()
    
    // Used For Screen Pts To Picture Pts Translation
    var imageSize: CGSize = CGSize.zero
    var imageTopOffset: CGFloat = 0.0
    var cameraAspectRatio: CGFloat = 0.0
    var imageHeightRelativeToScreen: CGFloat = 0.0
    
    var totalInches: Int = 0
    
    
    public func makeUIViewController(context: Context) -> SideViewController {
        self.sideviewController.sideControlView.delegate = context.coordinator
        return sideviewController
    }
    
    public func updateUIViewController(_ uiViewController: SideViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func calculateSize(completion: @escaping ()->() ) {
        //  Put this below "|| totalInches == 0"
        if !currentMeasurments.frontSet || !currentMeasurments.sideSet  {
            return
        }
        
        let totalInches = 5.75
        let imageSize = self.sideviewController.sideControlView.imageView!.image?.size

        
        // Get Actual Height In Pixels
        let frontHeightPixels = currentMeasurments.frontBottom - currentMeasurments.frontTop
        let sideHeightPixels = currentMeasurments.sideBottom - currentMeasurments.sideTop
        
        // Calculate The Pixels Per Inch For Front & Back
        // These Might Be Different As The Height Might Be Different In Each Picture
        // We Will Use This To Calculate How To Scale The Side Picture To Match The Front
        let frontPixelsPerInch = frontHeightPixels / CGFloat(totalInches)
        let sidePixelsPerInch = sideHeightPixels / CGFloat(totalInches)
        
        // Get Major Radius In Inches (Front Pic) & Minor Radius In Inches (Side Pic)
        let major_rad = ((abs(currentMeasurments.frontLeftX - currentMeasurments.frontRightX)) / frontPixelsPerInch)
        let minor_rad = ((abs(currentMeasurments.sideLeft - currentMeasurments.sideRight)) / sidePixelsPerInch)
        
        // Approximation Formula
        let a_minus_b_squared = (major_rad - minor_rad) * (major_rad - minor_rad)
        let a_plus_b_squared = (major_rad + minor_rad) * (major_rad + minor_rad)
        let h = a_minus_b_squared / a_plus_b_squared
        
        let pi_times_a_plus_b = .pi * (major_rad + minor_rad)
        let main_math = (1.0 + ((3.0 * h) / (10.0 + sqrt(4.0 - (3.0 * h)))))
       let   currentApproximation = (pi_times_a_plus_b * main_math) / 2.0
        
         let approx_inch = String(Int(currentApproximation))
        //  let approx_fraction = getDisplayFraction(currentApproximation)
        
        
        let convertPtLeft = self.convertPointToPicturePt(CGPoint(x: currentMeasurments.frontLeftX, y: currentMeasurments.frontLeftY), imageView: self.sideviewController.sideControlView.imageView!)
        let convertPtRight = self.convertPointToPicturePt(CGPoint(x: currentMeasurments.frontRightX, y: currentMeasurments.frontRightY), imageView: self.sideviewController.sideControlView.imageView!)
        let convertPtTop = self.convertPointToPicturePt(CGPoint(x: 0.0, y: currentMeasurments.frontTop) , imageView: self.sideviewController.sideControlView.imageView!)
        let convertPtBottom = self.convertPointToPicturePt(CGPoint(x: 0.0, y: currentMeasurments.frontBottom) , imageView: self.sideviewController.sideControlView.imageView!)
        
        print("Top: \(convertPtTop), Bottom: \(convertPtBottom), Right: \(convertPtRight), Left: \(convertPtLeft)")
        


        let leftNavalDic = [ "X" : Int(convertPtLeft.x), "Y" : Int(convertPtLeft.y) ]

        let rightNavalDic = [ "X" : Int(convertPtRight.x), "Y" : Int(convertPtRight.y) ]
        //            let encoder = JSONEncoder()
        //
        //            if let leftNavalDicData = try? encoder.encode(leftNavalDic) {
        //                globalValues.set(leftNavalDicData, forKey: "LeftNavalPointDictKey")
        //            }
        //
        //            if let rightNavalDicData = try? encoder.encode(rightNavalDic) {
        //                globalValues.set(rightNavalDicData, forKey: "RightNavalPointDictKey")
        //            }
        //
        //
        //            if let convertPtTopData = try? encoder.encode(convertPtTop.y) {
        //                globalValues.set(convertPtTopData, forKey: "TopOfHeadKey")
        //            }
        //
        //            if let convertPtBottomData = try? encoder.encode(convertPtBottom.y) {
        //                globalValues.set(convertPtBottomData, forKey: "BottomOfFeetKey")
        //            }
        //
        //            if let currentApproximationData = try? encoder.encode(currentApproximation) {
        //                globalValues.set(currentApproximationData, forKey: "currentApproximationKey")
        //            }
        //
        //
        //
        //
        //
        //    //        globalValues.set(rightNavalDic, forKey: "RightNavalPointDictKey")
        //    //        globalValues.set(convertPtTop.y, forKey: "TopOfHeadKey")
        //    //        globalValues.set(convertPtBottom.y, forKey: "BottomOfFeetKey")
        //
        //
        //
        //
        //
        //           // setSizeApproximation(approx_inch + " " + approx_fraction)
        //            self.sideDelegate.sideNewMeasurement(convertPtTop, left: convertPtLeft, bottom: convertPtBottom, right: convertPtRight, approximation: currentApproximation)
        print("Top: \(convertPtTop)")
        
        var normalizedBodyImage: UIImage? = nil
          let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
          let documentsDirectory = paths[0]
        
        
          
          let fileNameStr = documentsDirectory + "/com.smr.front.png"
          if let bodyImage = UIImage(contentsOfFile: fileNameStr) {
              // This Eliminates The Image Sending To The Server With The Wrong Orientation
              normalizedBodyImage = normalize(image: bodyImage)
          }
        
        if let normalizedImage = normalizedBodyImage,
            let imageData = normalizedImage.jpegData(compressionQuality: 0) {
//BBIModelEndpoint.sharedService.warpImageWithImageData(imageData, leftWaist: [0:0], rightWaist: [:], yKneeCoord: [:], leftNaval: leftNavalDic, rightNaval: rightNavalDic, leftHips: [:], rightHips: [:], midChest: [:], leftBi: [:], rightBi: [:], bodyTypeId: 3, waistInInches: 31, userId: "15572", blurface: 0)
            
            BBIModelEndpoint.sharedService.warpImageWithImageData(imageData, leftNavel: leftNavalDic, rightNavel: rightNavalDic, bodyTypeId: 3, topOfHead: Int(convertPtTop.y), bottomOfFeet: Int(convertPtBottom.y), heightInInches: Int(5.9), userName: "sagartech03@gmail.com", waistInInches: 31, userId: "15815", blurface: 1) { result in
                
                
                switch result {
                case .success(let warpImage):
                   // print(warpImage)
                    if warpImage.ResponseObject.ProcessedImages.count > 0 {
                        let warpImages =  warpImage.ResponseObject.ProcessedImages
                        print(warpImages)
                        let path = documentsDirectory + "/com.bbi.warpedImages"
                       // let urlPath = URL(fileURLWithPath: path)
                        let fileURL = try! FileManager.default
                        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        .appendingPathComponent("/com.bbi.warpedImages")
                        //NSKeyedArchiver.archiveRootObject(warpImages, toFile: path)
                        do {
                            let data = try NSKeyedArchiver.archivedData(withRootObject: warpImages, requiringSecureCoding: false)
                            try data.write(to: fileURL)
                            print("WarpImages successfully saved.")
                            completion()
                        } catch {
                            print("Failed to save \(error) ...")
                            completion()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
       
            
        }
    }
    
    func warpImage() {
        //        "UserId": 15572,
        
        
        
        
        
    }
    
    private func normalize(image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? UIImage()
    }
    
    
    // MARK: Convert Point To Picture Pt
    
    func convertPointToPicturePt(_ pt: CGPoint, imageView: UIImageView) -> CGPoint {
        let imageSize = self.sideviewController.sideControlView.imageView!.image?.size

        let translatedImagePtX = (pt.x / imageView.bounds.size.width) * imageSize!.width
        print(imageView.bounds.size.width)
        // Need To Account For Top And Bottom Padding In ImageView When Taking Pt Percentages For Y
        let adjustedYForTopOffset = pt.y - imageTopOffset
        let translatedImagePtY = (adjustedYForTopOffset / (imageView.bounds.size.height - (imageTopOffset * 2))) * imageSize!.height
        
        return CGPoint(x: translatedImagePtX, y: translatedImagePtY)
    }
    
    
    class Coordinator: NSObject, ControlViewDelegate {
        var parent: SideMainViewController
        init(_ parent: SideMainViewController) {
            self.parent = parent
        }
        
        func sideNewMeasurement(_ top: CGPoint, left: CGPoint, bottom: CGPoint, right: CGPoint, approximation: CGFloat) {
            print("Top: \(top)")
        }
        
        func newMeasurements(_ top: CGFloat, leftX: CGFloat, leftY: CGFloat, bottom: CGFloat, rightX: CGFloat, rightY: CGFloat) {
            // labelXConstant.constant = round(leftX) + 30.0
            //labelYConstant.constant = screenSize.height - 64.0 - round(leftY) + 20.0 // 64.0 Offset From Nav Bar
            
            currentMeasurments.sideSet = true
            currentMeasurments.sideTop = top
            currentMeasurments.sideLeft = leftX
            currentMeasurments.sideBottom = bottom
            currentMeasurments.sideRight = rightX
            print("Side: \(top)")
            
        }
        
    }
    
    
    
}
