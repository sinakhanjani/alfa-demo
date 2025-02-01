//
//  Auth.swift
//
//  Created by Sina khanjani on 2/31/1400 AP.
//

import Foundation
import RestfulAPI

/// This class `Auth` is used to manage specific logic in the application.
struct Auth {
    public static var shared = Auth()
        
    public var account: Authentication = .auth1
    
    public var isLogin: Bool {
        account.isLogin
    }
    
    public var token: String? {
        account.token
    }
    
    public mutating func authenticate(with token: String) {
        account.authenticate(token: token)
    }
    
    public mutating func logout() {
        account.logout()
        Setting.savePassword = false
        Setting.changeBaseURL(to: "http://194.5.195.190:82/api")
    }
}

