//
//  AnimatedGifClass.swift


import Foundation
import ImageIO
import UIKit

class AnimatedGifObject  
{
    var         duration:       Double          = 0.0
    var         frameCount:     Int             = 0
    var         size:           CGSize          = .zero
    var         imageSource:    CGImageSource?  = nil
    var         pixelWidth:     Int!            = 0
    var         pixelHeight:    Int!            = 0
    var         fps:            Float!          = 0
    var         fpsUC:          Float!          = 0
    var         frameInterval:  Double          = 0.04
    
    private var lastCgi : CGImage?  = nil
    private var blank : CIImage! = CIImage.init(contentsOf: Bundle.main.url(forResource: "Blank", withExtension: "jpg")!)
    
    
    
    init?(url: URL)
    {
        imageSource                             =  CGImageSourceCreateWithURL(url as CFURL, nil)
        
        if imageSource != nil
        {
            let metadata    =  CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil )  as Dictionary?
            guard metadata != nil else  { return }
            
            pixelWidth          =  metadata?[kCGImagePropertyPixelWidth] as? Int
            pixelHeight         =  metadata?[kCGImagePropertyPixelHeight] as? Int
            size                =  CGSize(width: pixelWidth, height: pixelHeight)
            
            let gifDict         = (metadata?[kCGImagePropertyGIFDictionary])
            guard gifDict != nil else { return nil }
            
            let gifData         = (metadata?[kCGImagePropertyGIFDictionary])!  as? Dictionary<String, AnyObject>
            
            if gifData != nil
            {
                let n1 : NSNumber? = gifData?[ kCGImagePropertyGIFUnclampedDelayTime as String ] as! NSNumber?
                let n2 : NSNumber? = gifData?[ kCGImagePropertyGIFDelayTime as String ] as! NSNumber?
                
                if n1 != nil  { fpsUC = n1?.floatValue }
                if n2 != nil  { fps   = n2?.floatValue }
                
                if fpsUC > 0  { fpsUC = 1.0 / fpsUC }
                if fps   > 0  { fps   = 1.0 / fps   }
                
                if fpsUC < 6 || fpsUC > 30 { fpsUC = 24 }
                
            } // End Valid Dictionary
        } // end Valid Source
       
        frameCount      =  CGImageSourceGetCount(imageSource!)
        
        // Override for this App
        if fps < 6   { fps = 6.0  }
        if fps > 24  { fps = 24.0 }
        
        
        duration        =  Double(frameCount) / Double(  fps  )
        frameInterval   = 1.0 / Double( fps )
        
        //print(frameInterval)
        
    } // End Init
    
    //          G e t     1    F r a m e
    
    func imageAtIndex(index: Int) -> CGImage?
    {
        if index < frameCount
        {
            let testGgi = CGImageSourceCreateImageAtIndex(imageSource!, index, nil)
            if testGgi == nil { lastCgi = cgiFrom(cii: blank )} else { lastCgi = testGgi }
            return lastCgi
        }
        else
        {
            return cgiFrom(cii: blank!)
        }
    }
    
}

func cgiFrom(cii: CIImage) -> CGImage?
{
    let context = CIContext(options: nil)
    if let cgImage = context.createCGImage(cii, from: cii.extent)
    {
        return cgImage
    }
    return nil
}







