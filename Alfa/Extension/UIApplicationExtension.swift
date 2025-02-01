//
//  UIApplicationExtension.swift
//  JobLoyal
//
//  Created by Sina khanjani on 3/30/1400 AP.
//

import UIKit
import RestfulAPI

extension UIApplication {
/// This variable `keyWindow` is used to store a specific value in the application.
    var keyWindow: UIWindow? {
        // Get connected scenes
//        return UIApplication.shared.connectedScenes
//            // Keep only active scenes, onscreen and visible to the user
//            .filter { $0.activationState == .foregroundActive }
//            // Keep only the first `UIWindowScene`
//            .first(where: { $0 is UIWindowScene })
//            // Get its associated windows
//            .flatMap({ $0 as? UIWindowScene })?.windows
//            // Finally, keep only the key window
//            .first(where: \.isKeyWindow)
        
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    }

}


extension UIApplication {
    static var appVersion: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String }
    static var appBuild: String { Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String }
    static var deviceID: String? { UIDevice.current.identifierForVendor?.uuidString }
    static var deviceType: String { UIDevice().model }
    static var deviceName: String { UIDevice.current.name }

    static func set(root viewController: UIViewController) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow!.rootViewController = viewController
            UIApplication.shared.keyWindow!.makeKeyAndVisible()
        }
    }
}


