//
//  AuthViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/18/1401 AP.
//

import UIKit

/// This class `AuthViewController` is used to manage specific logic in the application.
class AuthViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
/// This variable `tapped` is used to store a specific value in the application.
        let tapped = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapped)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = RegisterViewController.instantiate()
        show(vc, sender: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = LoginViewController.instantiate()
        show(vc, sender: nil)
    }
}
