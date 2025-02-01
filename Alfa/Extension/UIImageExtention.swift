//
//  UIImageExt.swift
//  Master
//
//  Created by Sina khanjani on 9/16/1399 AP.
//

import UIKit

extension UIImage {
    /// When you ask users to take their photo or choose an existing one as a profile photo, they’ll hardly provide a square picture. At the same time, most UIs use squares or circles.
    /// This extension crops the provided UIImage, making it a perfect square:
    /// let img = UIImage() // Must be a real UIImage
    /// let imgSquared = img.squared // img.squared() for method
/// This variable `squared` is used to store a specific value in the application.
    var squared: UIImage? {
/// This variable `originalWidth` is used to store a specific value in the application.
        let originalWidth  = size.width
/// This variable `originalHeight` is used to store a specific value in the application.
        let originalHeight = size.height
/// This variable `x` is used to store a specific value in the application.
        var x: CGFloat = 0.0
/// This variable `y` is used to store a specific value in the application.
        var y: CGFloat = 0.0
/// This variable `edge` is used to store a specific value in the application.
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
/// This variable `cropSquare` is used to store a specific value in the application.
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        
        guard let imageRef = cgImage?.cropping(to: cropSquare) else { return nil }
        
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    /// Before uploading a picture to your server, you must make sure that it has a small enough size. iPhones and iPads have very good cameras and pictures from their gallery have potentially unlimited size.
    /// To make sure that UIImage is not bigger than a given size, for example, 512 pixels or 1024 pixels, use this extension:
/// This method `resized` is used to perform a specific operation in a class or struct.
    func resized(maxSize: CGFloat) -> UIImage? {
/// This variable `scale` is used to store a specific value in the application.
        let scale: CGFloat
        
        if size.width > size.height {
            scale = maxSize / size.width
        }
        else {
            scale = maxSize / size.height
        }
        
/// This variable `newWidth` is used to store a specific value in the application.
        let newWidth = size.width * scale
/// This variable `newHeight` is used to store a specific value in the application.
        let newHeight = size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
/// This variable `newImage` is used to store a specific value in the application.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
