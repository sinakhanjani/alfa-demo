//
//  Config.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 7/25/1400 AP.
//

import Foundation
import RestfulAPI

/// This class `Setting` is used to manage specific logic in the application.
struct Setting {
    static public var isFaceIDEnable: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isFaceIDEnable")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFaceIDEnable")
        }
    }
    
    static public var chached: Bool {
        get {
            UserDefaults.standard.bool(forKey: "CHACECH")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CHACECH")
        }
    }
    
    static public var passworrd: String? {
        get {
            UserDefaults.standard.value(forKey: "PASSWORD") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PASSWORD")
        }
    }
    
    static public var savePassword: Bool {
        get {
            UserDefaults.standard.bool(forKey: "SAVE_PASSWORD")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SAVE_PASSWORD")
        }
    }
    
    static public private(set) var baseURL: String {
        get {
            UserDefaults.standard.value(forKey: "BASE_URL") as? String ?? "http://194.5.195.190:82/api"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "BASE_URL")
        }
    }
    
    static func changeBaseURL(to baseURL: String) {
        self.baseURL = baseURL
        
        RestfulAPIConfiguration().setup { () -> APIConfiguration in
            APIConfiguration(baseURL: baseURL)
        }
    }
}
