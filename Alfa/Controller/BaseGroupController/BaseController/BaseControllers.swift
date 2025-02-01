//
//  BaseViewController.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 7/25/1400 AP.
//

import UIKit

/// This class `BaseViewController` is used to manage specific logic in the application.
class BaseViewController: InterfaceViewController, BaseControllerDelegate {
/// This variable `data` is used to store a specific value in the application.
    var data: [String:Any]?
}

/// This class `BaseTableViewController` is used to manage specific logic in the application.
class BaseTableViewController: InterfaceTableViewController, BaseControllerDelegate {
/// This variable `data` is used to store a specific value in the application.
    var data: [String:Any]?
}

/// This class `BaseCollectionViewController` is used to manage specific logic in the application.
class BaseCollectionViewController: InterfaceCollectionViewController, BaseControllerDelegate {
/// This variable `data` is used to store a specific value in the application.
    var data: [String:Any]?
}
