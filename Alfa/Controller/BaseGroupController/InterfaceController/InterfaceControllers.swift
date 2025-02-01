//
//  InterfaceViewController.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 7/25/1400 AP.
//

import UIKit
import MapKit

/// This protocol `InterfaceDelegate` defines the required contracts for implementation.
protocol InterfaceDelegate: UIViewController {
/// This method `configUI` is used to perform a specific operation in a class or struct.
    func configUI()
/// This method `updateUI` is used to perform a specific operation in a class or struct.
    func updateUI()
}

extension InterfaceDelegate {
/// This method `navigationControllerConfiguration` is used to perform a specific operation in a class or struct.
    func navigationControllerConfiguration() {
/// This variable `backButton` is used to store a specific value in the application.
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.setTitleTextAttributes([.font: UIFont.iranSans(.bold, size: 17)], for: .normal)
        backButton.tintColor = .label
    
        navigationItem.backBarButtonItem = backButton
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
    }
}

/// This class `InterfaceViewController` is used to manage specific logic in the application.
class InterfaceViewController: NetworkViewController, InterfaceDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerConfiguration()
        configUI()
        updateUI()
    }
/// This method `configUI` is used to perform a specific operation in a class or struct.
    func configUI() {

    }

/// This method `updateUI` is used to perform a specific operation in a class or struct.
    func updateUI() {
        //
    }

}

/// This class `InterfaceTableViewController` is used to manage specific logic in the application.
class InterfaceTableViewController: NetworkTableViewController, InterfaceDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerConfiguration()
        configUI()
        updateUI()
    }
/// This method `configUI` is used to perform a specific operation in a class or struct.
    func configUI() {

    }

/// This method `updateUI` is used to perform a specific operation in a class or struct.
    func updateUI() {
        //
    }
}

/// This class `InterfaceCollectionViewController` is used to manage specific logic in the application.
class InterfaceCollectionViewController: NetworkCollecitonViewController, InterfaceDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerConfiguration()
        configUI()
        updateUI()
    }
/// This method `configUI` is used to perform a specific operation in a class or struct.
    func configUI() {

    }

/// This method `updateUI` is used to perform a specific operation in a class or struct.
    func updateUI() {
        //
    }
}
