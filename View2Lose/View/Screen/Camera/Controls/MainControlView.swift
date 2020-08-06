//
//  MainControlView.swift
//  SizeMeRight
//
//  Created by Jared Manfredi on 3/27/16.
//  Copyright © 2016 BBI. All rights reserved.
//

import UIKit
import Combine

class Measurements : ObservableObject {
	var frontSet: Bool = false
	var sideSet: Bool = false
	
	var frontTop: CGFloat = -1.0
	var frontLeftX: CGFloat = -1.0
	var frontLeftY: CGFloat = -1.0
	var frontBottom: CGFloat = -1.0
	var frontRightX: CGFloat = -1.0
	var frontRightY: CGFloat = -1.0
	var sideTop: CGFloat = -1.0
	var sideLeft: CGFloat = -1.0
	var sideBottom: CGFloat = -1.0
	var sideRight: CGFloat = -1.0
}

struct BodyImages {
	var frontImage: UIImage?
	var sideImage: UIImage?
}

enum PhotoType {
	case front, side
}

protocol ControlViewDelegate: class {
	func newMeasurements(_ top: CGFloat, leftX: CGFloat, leftY: CGFloat, bottom: CGFloat, rightX: CGFloat, rightY: CGFloat)
}

// Cursor Size Constants
let cursorTopBottomSize: CGFloat = 60.0
let cursorLeftRightSize: CGFloat = 40.0
let cursorMarginSize: CGFloat = 20.0

public class MainControlView: UIView, ObservableObject, Identifiable
{
	weak var delegate: ControlViewDelegate?
	let WillChange = PassthroughSubject<Measurements, Never>()
	
	var imageView: UIImageView?
	{ didSet {
			magGlassLeft.imageToMagnify = imageView
			magGlassRight.imageToMagnify = imageView
			magGlassTop.imageToMagnify = imageView
			magGlassBottom.imageToMagnify = imageView
	} }
	
	var cursorButtonLeft: CursorButton = CursorButton(frame: CGRect.zero, type: .free, diameter: cursorLeftRightSize, isTop: false)
	var cursorButtonRight: CursorButton = CursorButton(frame: CGRect.zero, type: .free, diameter: cursorLeftRightSize, isTop: false)
	var cursorButtonTop: CursorButton = CursorButton(frame: CGRect.zero, type: .vertical, diameter: cursorTopBottomSize, isTop: true)
	var cursorButtonBottom: CursorButton = CursorButton(frame: CGRect.zero, type: .vertical, diameter: cursorTopBottomSize, isTop: false)
	
	var cursorPanLeft: UIPanGestureRecognizer?
	var cursorPanRight: UIPanGestureRecognizer?
	var cursorPanTop: UIPanGestureRecognizer?
	var cursorPanBottom: UIPanGestureRecognizer?
	
	var supportLoupe: Bool = false
	var magGlassLeft: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .round)
	var magGlassRight: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .round)
	var magGlassTop: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .square)
	var magGlassBottom: MagnifyingView = MagnifyingView(frame: CGRect.zero, type: .square_BOTTOM)
	
	var indicatorViewLeft: IndicatorView = IndicatorView(withSide: .left)
	var indicatorViewRight: IndicatorView = IndicatorView(withSide: .right)
	
	var topMask: TopMaskView = TopMaskView()
	var bottomMask: BottomMaskView = BottomMaskView()
	
	let screenSize = UIScreen.main.bounds
	var lineLayer = CAShapeLayer()
	var imageHeight: CGFloat = 0.0
	var imageSizeScreenOffset: CGFloat = 0.0
	
	var initialSubviewLayout: Bool = false
	
	var currentMeasurments = Measurements()
	
	
	func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
		let oldWidth = sourceImage.size.width
		let scaleFactor = 4.0/3.0 // scaledToWidth / oldWidth
		
		let newHeight = sourceImage.size.height * CGFloat(scaleFactor)
		let newWidth = oldWidth
		
		UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
		sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage!
	}
	
	private func getDocumentsDirectory() -> NSString {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let documentsDirectory = paths[0]
		return documentsDirectory as NSString
	}
	
	required init?(coder aDecoder: NSCoder)
	{ super.init(coder: aDecoder) }
	
	required init(imageName: String) {
		super.init(frame: CGRect.zero)
		
		self.imageView = UIImageView()
		let filename = getDocumentsDirectory().appendingPathComponent(imageName)
		if let image = UIImage(contentsOfFile: filename)
		{ self.imageView!.image = imageWithImage(sourceImage: image, scaledToWidth: 0.3) }
		
		self.imageView!.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(self.imageView!)
		self.imageView!.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		self.imageView!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		self.imageView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
		self.imageView!.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		
		let cameraAspectRatio = CGFloat(4.0/3.0)
		imageHeight = screenSize.width * cameraAspectRatio
		imageSizeScreenOffset = (screenSize.size.height - imageHeight) / 2.0
		// Setup Hack Check Because Of Poor Performance On Old Devices With Loupe Effect
		//setupSupportedHardwareSet()
		supportLoupe = false //shouldSupportLoupeEffect(DeviceUtil.hardware())
		self.initialSubviewLayout = true
		
		cursorButtonTop.imageView?.image = UIImage(named: "down")
		setupViewAndControls()
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if self.initialSubviewLayout {
			self.initialSubviewLayout = false
			
			// Top Cursor & Mask
			cursorButtonTop.frame = CGRect(x: 10.0, y: 20.0, width: cursorTopBottomSize, height: cursorTopBottomSize)
			topMask.touchPoint = CGPoint(x: 0, y: 20.0 + cursorTopBottomSize/2.0)
			
			// Bottom Cursor & Mask
			cursorButtonBottom.frame = CGRect(x: 10.0, y: self.frame.size.height - cursorTopBottomSize - 20.0, width: cursorTopBottomSize, height: cursorTopBottomSize)
			bottomMask.touchPoint = CGPoint(x: 0, y: self.frame.size.height - cursorTopBottomSize/2.0 - 20.0 + 5.0)
			
			// Left Cursor & Indicator )
			cursorButtonLeft.frame = CGRect(x: self.frame.size.width/4.0 - cursorLeftRightSize/2.0,
											y: self.frame.size.height/2.0 - cursorLeftRightSize/2.0,
											width: cursorLeftRightSize, height: cursorLeftRightSize)
			cursorButtonLeft.touchPoint = CGPoint(x: cursorButtonLeft.frame.origin.x + cursorLeftRightSize/2.0,
												  y: cursorButtonLeft.frame.origin.y + cursorLeftRightSize/2.0) // This needs set so that first touch of cursor will match other cursors y and not be 0
			indicatorViewLeft.frame = CGRect(x: self.frame.size.width/4.0 - 2,
											 y: self.frame.size.height/2.0 - cursorLeftRightSize - 1.0,
											 width: 4.0, height: 4.0)
			indicatorViewLeft.touchPoint = cursorButtonLeft.touchPoint // This needs set so that first touch of cursor will match other indicators y and not be 0
			
			// Right Cursor & Indicator
			cursorButtonRight.frame = CGRect(x: self.frame.size.width*(3.0/4.0) - cursorLeftRightSize/2.0, y: self.frame.size.height/2.0 - cursorLeftRightSize/2.0, width: cursorLeftRightSize, height: cursorLeftRightSize)
			
			cursorButtonRight.touchPoint = CGPoint(x: cursorButtonRight.frame.origin.x + cursorLeftRightSize/2.0, y: cursorButtonRight.frame.origin.y + cursorLeftRightSize/2.0) // This needs set so that first touch of cursor will match other cursors y and not be 0
			indicatorViewRight.frame = CGRect(x: self.frame.size.width*(3.0/4.0) - 2.0, y: self.frame.size.height/2.0 - cursorLeftRightSize - 1.0, width: 4.0, height: 4.0)
			indicatorViewRight.touchPoint = cursorButtonRight.touchPoint // This needs set so that first touch of cursor will match other indicators y and not be 0
			
			// Draw Connecting Line
			drawLine()
		}
	}
	
	// MARK:- Setup View And Controls
	
	func setupViewAndControls() {
		// Top/Bottom Masks
		self.addSubview(topMask)
		self.addSubview(bottomMask)
		
		cursorPanLeft = UIPanGestureRecognizer(target: self, action: #selector(panButton))
		cursorPanRight = UIPanGestureRecognizer(target: self, action: #selector(panButton))
		cursorPanBottom = UIPanGestureRecognizer(target: self, action: #selector(panButton))
		cursorPanTop = UIPanGestureRecognizer(target: self, action: #selector(panButton))
		
		// Left Cursor Button
		cursorButtonLeft.addGestureRecognizer(cursorPanLeft!)
		cursorButtonLeft.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
		cursorButtonLeft.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
		
		self.addSubview(indicatorViewLeft)
		
		// Right Cursor Button
		cursorButtonRight.addGestureRecognizer(cursorPanRight!)
		cursorButtonRight.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
		cursorButtonRight.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
		
		self.addSubview(indicatorViewRight)
		self.addSubview(cursorButtonLeft)
		self.addSubview(cursorButtonRight)
		
		// Bottom Cursor For Feet
		cursorButtonBottom.addGestureRecognizer(cursorPanBottom!)
		cursorButtonBottom.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
		cursorButtonBottom.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
		
		// Top Cursor
		cursorButtonTop.addGestureRecognizer(cursorPanTop!)
		cursorButtonTop.addTarget(self, action: #selector(MainControlView.loupeButtonDown(_:)), for: .touchDown)
		cursorButtonTop.addTarget(self, action: #selector(MainControlView.loupeButtonUp(_:)), for: .touchUpInside)
		self.addSubview(cursorButtonTop)
		self.addSubview(cursorButtonBottom)
		
		// Set Up Connecting Line
		lineLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor;
		lineLayer.lineWidth = 1.0;
		self.layer.addSublayer(lineLayer)
	}
	
	func resetControls() {
		func resetControls() {
			self.initialSubviewLayout = true
			self.setNeedsLayout()
		}
	}
	
	// MARK:- Magnifying Glass Methods
	
	fileprivate func addMagnifyingGlass(_ magGlass: MagnifyingView, atPoint point: CGPoint, forCursor cursor: CursorButton)
	{
		var currentIndicator = indicatorViewLeft
		if magGlass === magGlassRight {
			currentIndicator = indicatorViewRight
		}
		magGlass.touchPoint = point
		self.insertSubview(magGlass, belowSubview: currentIndicator)
		
		magGlass.setNeedsDisplay()
	}
	
	fileprivate func updateMagnifyingGlass(_ magGlass: MagnifyingView, atPoint point: CGPoint) {
		magGlass.touchPoint = point
		magGlass.setNeedsDisplay()
	}
	
	fileprivate func removeMagnifyingGlass(_ magGlass: MagnifyingView) {
		magGlass.removeFromSuperview()
	}
	
	// MARK:- Update Cursor Button
	
	fileprivate func updateCursorButtonAtPoint(_ point: CGPoint, cursor: CursorButton) {
		// Update Masks If Needed
		if cursor === cursorButtonTop {
			topMask.touchPoint = point
			topMask.setNeedsDisplay()
		} else if cursor === cursorButtonBottom {
			bottomMask.touchPoint = point
			bottomMask.setNeedsDisplay()
		} else if (cursor === cursorButtonLeft) {
			// Left Cursor
			// We need to match y for each
			cursorButtonRight.touchPoint.y = point.y
			cursorButtonRight.setNeedsDisplay()
		} else {
			// Right Cursor
			// We need to match y for each
			cursorButtonLeft.touchPoint.y = point.y
			cursorButtonLeft.setNeedsDisplay()
		}
		cursor.touchPoint = point
		cursor.setNeedsDisplay()
	}
	
	// MARK:- Update Indicator
	
	fileprivate func updateIndicatorAtPoint(_ point: CGPoint, indicator: IndicatorView) {
		indicator.touchPoint = point
		indicator.setNeedsDisplay()
		if (indicator === indicatorViewLeft) {
			// Match right y
			self.indicatorViewRight.touchPoint.y = point.y
			self.indicatorViewRight.setNeedsDisplay()
		} else {
			// Match left y
			self.indicatorViewLeft.touchPoint.y = point.y
			self.indicatorViewLeft.setNeedsDisplay()
		}
	}
	
	// MARK:- Button Down
	
	@IBAction func loupeButtonDown(_ sender: UIButton) {
		var currentMagGlass = magGlassLeft
		if sender === cursorButtonRight {
			currentMagGlass = magGlassRight
		} else if sender === cursorButtonTop {
			currentMagGlass = magGlassTop
		} else if sender === cursorButtonBottom {
			currentMagGlass = magGlassBottom
		}
		
		// If We Are On An Older Device, The Scaling Of The Image Is Poop
		// Trying To Filter Out This Functionality For Older Devices For Now
		if supportLoupe {
			addMagnifyingGlass(currentMagGlass, atPoint: sender.center, forCursor: sender as! CursorButton)
		}
	}
	
	@IBAction func loupeButtonUp(_ sender: UIButton) {
		var currentMagGlass = magGlassLeft
		if sender === cursorButtonRight {
			currentMagGlass = magGlassRight
		} else if sender === cursorButtonTop {
			currentMagGlass = magGlassTop
		} else if sender === cursorButtonBottom {
			currentMagGlass = magGlassBottom
		}
		removeMagnifyingGlass(currentMagGlass)
	}
	
	// MARK:- Pan Gesture From Buttons
	@objc func panButton(_ gesture: UIPanGestureRecognizer) {
		let imageBounds = self.imageView!.bounds
		var updatedPt = gesture.location(in: self.imageView)
		var currentMagGlass: MagnifyingView? = magGlassLeft
		var currentIndicator: IndicatorView? = indicatorViewLeft
		
		if gesture.view! === cursorButtonRight {  // RIGHT
			currentMagGlass = magGlassRight
			currentIndicator = indicatorViewRight
			
			// Restrict Right Cursor (This is the center pt so offset as needed)
			updatedPt.x = max(min(imageBounds.width, updatedPt.x), indicatorViewLeft.center.x)
			updatedPt.y = min(max(updatedPt.y, 78.0), imageBounds.height - 35.0) // 78.0 is indicator offset from cursor center
		} else if gesture.view! === cursorButtonBottom { // BOTTOM
			currentMagGlass = magGlassBottom
			currentIndicator = nil
			
			// Restrict Bottom Cursor (This is the center pt so offset as needed)
			updatedPt.x = 40.0
			updatedPt.y = max(min(updatedPt.y, imageBounds.height - 20.0), imageBounds.height/2)
		} else if gesture.view! === cursorButtonTop { // TOP
			currentMagGlass = magGlassTop
			currentIndicator = nil
			
			// Restrict Top Cursor (This is the center pt so offset as needed)
			updatedPt.x = 40.0
			updatedPt.y = max(min(updatedPt.y, imageBounds.height/2), 30.0)
		} else { // LEFT
			// Restrict Left Cursor (This is the center pt so offset as needed)
			updatedPt.x = min(max(0.0, updatedPt.x), indicatorViewRight.center.x)
			updatedPt.y = min(max(updatedPt.y, 78.0), imageBounds.height - 35.0) // 78.0 is indicator offset crom cursor center
		}
		
		switch gesture.state {
			case .changed:
				if let currentMagGlass = currentMagGlass {
					updateMagnifyingGlass(currentMagGlass, atPoint: updatedPt)
				}
				if let currentIndicator = currentIndicator {
					updateIndicatorAtPoint(updatedPt, indicator: currentIndicator)
				}
				updateCursorButtonAtPoint(updatedPt, cursor: gesture.view as! CursorButton)
				drawLine()
				break
			case .ended:
				if let currentMagGlass = currentMagGlass {
					removeMagnifyingGlass(currentMagGlass)
				}
				break
			default: ()
		}
		
		updateMeasurements()
	}
	
	// Draw Connecting Line
	
	func drawLine() {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: indicatorViewLeft.center.x + 15, y: indicatorViewLeft.center.y))
		path.addLine(to: CGPoint(x: indicatorViewRight.center.x - 15, y: indicatorViewRight.center.y))
		path.close()
		
		lineLayer.path = path.cgPath
	}
	
	// Update Measurements
	
	func updateMeasurements() {
		delegate?.newMeasurements(cursorButtonTop.center.y,
								  leftX: indicatorViewLeft.center.x + 15,
								  leftY:  indicatorViewLeft.center.y,
								  bottom: cursorButtonBottom.center.y,
								  rightX: indicatorViewRight.center.x - 15,
								  rightY: indicatorViewRight.center.y)
	}
	
	// MARK:- Convert Point To Picture Pt
	// Used For Screen Pts To Picture Pts Translation
	var imageSize: CGSize = CGSize.zero
	var imageTopOffset: CGFloat = 0.0
	var cameraAspectRatio: CGFloat = 0.0
	var imageHeightRelativeToScreen: CGFloat = 0.0
	
	func convertPointToPicturePt(_ pt: CGPoint, imageView: UIImageView) -> CGPoint {
		let translatedImagePtX = (pt.x / imageView.bounds.size.width) * imageSize.width
		
		// Need To Account For Top And Bottom Padding In ImageView When Taking Pt Percentages For Y
		let adjustedYForTopOffset = pt.y - imageTopOffset
		let translatedImagePtY = (adjustedYForTopOffset / (imageView.bounds.size.height - (imageTopOffset * 2))) * imageSize.height
		
		return CGPoint(x: translatedImagePtX, y: translatedImagePtY)
	}
}
