//
//  AlertContent.swift
//  TEST
//
//  Created by Sina khanjani on 12/10/1399 AP.
//

import SwiftUI
import UIKit

final class AlertContent {
    internal enum AlertTitle: String, CaseIterable, Codable {
        case cancel = "انصراف"
        case none = "توجه"
        case delete = "حذف"
        case update = "بروز رسانی"
        
/// This variable `value` is used to store a specific value in the application.
        var value: String { rawValue }
    }
    
/// This variable `title` is used to store a specific value in the application.
    var title: AlertTitle
/// This variable `subject` is used to store a specific value in the application.
    var subject: String
/// This variable `description` is used to store a specific value in the application.
    var description: String
        
    internal init(title: AlertTitle, subject: String, description: String) {
        self.title = title
        self.subject = subject
        self.description = description
    }
}
