//
//  FrontViewController.swift
//  View2Lose
//
//  Created by Sagar on 17/6/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

protocol FrontViewDelegate: class {
    func newFrontMeasurements(_ top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)

}


class FrontViewController: UIViewController {
  
    
    let screenSize = UIScreen.main.bounds
    weak var delegate: FrontViewDelegate?
    var currentMeasurments = Measurements()

    var frontControlView: MainControlView   = MainControlView(imageName: "com.smr.front.png")
    
    // Used For Screen Pts To Picture Pts Translation
     var imageSize: CGSize = CGSize.zero
     var imageTopOffset: CGFloat = 0.0
     var cameraAspectRatio: CGFloat = 0.0
     var imageHeightRelativeToScreen: CGFloat = 0.0
    
    var continueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Continue", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var topLabel: UILabel = {
        let label = UILabel()
        label.text = "FRONT VIEW"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var photoLabel: UILabel = {
        let photoLabel = UILabel()
        photoLabel.text = "PHOTO"
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        photoLabel.textColor = #colorLiteral(red: 0.9408810735, green: 0.753742516, blue: 0.001838603755, alpha: 1)
        return photoLabel
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.frontControlView.delegate = self
        currentMeasurments = Measurements()
        
        view.addSubview(topLabel)
        view.addSubview(frontControlView)

        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topLabel.bottomAnchor.constraint(equalTo: frontControlView.topAnchor).isActive = true
        topLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        frontControlView.translatesAutoresizingMaskIntoConstraints = false
        
        frontControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        frontControlView.topAnchor.constraint(equalTo: topLabel.topAnchor,constant: 10).isActive = true
        frontControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Used For Screen Pts To Picture Pts Translation
       imageSize = self.frontControlView.imageView?.image?.size ?? CGSize.zero
       cameraAspectRatio = CGFloat(4.0/3.0)
       
       // Used For Screen Pts To Picture Pts Translation
       imageHeightRelativeToScreen = screenSize.width * cameraAspectRatio
       imageTopOffset = ((self.frontControlView.imageView?.bounds.height)! - imageHeightRelativeToScreen) / 2.0
        
        frontControlView.heightAnchor.constraint(equalToConstant: imageHeightRelativeToScreen).isActive = true
        
        //view.addSubview(continueButton)
//        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        continueButton.topAnchor.constraint(equalTo: frontControlView!.bottomAnchor).isActive = true
//        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
       
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let filename = getDocumentsDirectory().appendingPathComponent("com.smr.front.png")
        if let image = UIImage(contentsOfFile: filename) {
          //  frontControlView = MainControlView(imageName: )
            self.frontControlView.imageView!.image = image
        }
        
    }
    
    // MARK: Get Documents Directory
       
       func getDocumentsDirectory() -> NSString {
           let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
           let documentsDirectory = paths[0]
           return documentsDirectory as NSString
       }
       
       // Control View Delegate
       // Measurement Controls Have Changed
//       func newMeasurements(_ top: CGFloat, leftX: CGFloat, leftY: CGFloat, bottom: CGFloat, rightX: CGFloat, rightY: CGFloat) {
//           currentMeasurments.frontSet = true
//           currentMeasurments.frontTop = top
//           currentMeasurments.frontLeftX = leftX
//           currentMeasurments.frontLeftY = leftY
//           currentMeasurments.frontBottom = bottom
//           currentMeasurments.frontRightX = rightX
//           currentMeasurments.frontRightY = rightY
//        
//       }
}
