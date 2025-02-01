//
//  UIImageExtension.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 8/1/1400 AP.
//
import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension UIImage {
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
                    print("SwiftGif: This image named \"\(name)\" does not exist")
                    return nil
                }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        return gifImageWithData(imageData)
    }
    
/// This class `func` is used to manage specific logic in the application.
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
/// This variable `delay` is used to store a specific value in the application.
        var delay = 0.1
/// This variable `cfProperties` is used to store a specific value in the application.
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
/// This variable `gifProperties` is used to store a specific value in the application.
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
/// This variable `delayObject` is used to store a specific value in the application.
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        delay = delayObject as! Double
        if delay < 0.1 {
            delay = 0.1
        }
        return delay
    }
    
/// This class `func` is used to manage specific logic in the application.
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
/// This variable `a` is used to store a specific value in the application.
        var a = a
/// This variable `b` is used to store a specific value in the application.
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        if a < b {
/// This variable `c` is used to store a specific value in the application.
            let c = a
            a = b
            b = c
        }
/// This variable `rest` is used to store a specific value in the application.
        var rest: Int
        while true {
            rest = a! % b!
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
/// This class `func` is used to manage specific logic in the application.
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
/// This variable `gcd` is used to store a specific value in the application.
        var gcd = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }
    
/// This class `func` is used to manage specific logic in the application.
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
/// This variable `count` is used to store a specific value in the application.
        let count = CGImageSourceGetCount(source)
/// This variable `images` is used to store a specific value in the application.
        var images = [CGImage]()
/// This variable `delays` is used to store a specific value in the application.
        var delays = [Int]()
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
/// This variable `delaySeconds` is used to store a specific value in the application.
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
/// This variable `duration` is used to store a specific value in the application.
        let duration: Int = {
/// This variable `sum` is used to store a specific value in the application.
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
/// This variable `gcd` is used to store a specific value in the application.
        let gcd = gcdForArray(delays)
/// This variable `frames` is used to store a specific value in the application.
        var frames = [UIImage]()
/// This variable `frame` is used to store a specific value in the application.
        var frame: UIImage
/// This variable `frameCount` is used to store a specific value in the application.
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
/// This variable `animation` is used to store a specific value in the application.
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        return animation
    }
}
