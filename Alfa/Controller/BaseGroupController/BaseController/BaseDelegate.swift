//
//  BaseDelegate.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 8/1/1400 AP.
//

import UIKit

/// This protocol `BaseControllerDelegate` defines the required contracts for implementation.
protocol BaseControllerDelegate: UIViewController {
/// This variable `data` is used to store a specific value in the application.
    var data: [String: Any]? { get set }
/// This method `with` is used to perform a specific operation in a class or struct.
    func with(passing data: [String: Any]) -> Self
}

extension BaseControllerDelegate {
/// This method `with` is used to perform a specific operation in a class or struct.
    func with(passing data: [String: Any]) -> Self {
        self.data = data
        
        return self
    }
}
