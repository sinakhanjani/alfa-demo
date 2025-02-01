//
//  EnterPasswordViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import UIKit

/// This class `EnterPasswordViewController` is used to manage specific logic in the application.
class EnterPasswordViewController: UIViewController {
    
/// This variable `completion` is used to store a specific value in the application.
    var completion: ((_ state: Bool) -> Void)?

    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if let faceIDPassword = Setting.passworrd {
            if !passwordTextField.text!.isEmpty {
                if faceIDPassword == passwordTextField.text! {
                    self.dismiss(animated: true) { [weak self] in
                        self?.completion?(true)
                        return
                    }
                }
            }
        }
        
        self.showAlerInScreen(body: "رمز عبور اکانت اشتباه است")
    }
}
