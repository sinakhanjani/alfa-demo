//
//  ForgotPasswordViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/18/1401 AP.
//

import UIKit
import RestfulAPI

/// This class `ForgotPasswordViewController` is used to manage specific logic in the application.
class ForgotPasswordViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!

/// This variable `mobile` is used to store a specific value in the application.
    var mobile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.delegate = self // set delegate
        passwordTextField.delegate = self // set delegate

/// This variable `tapped` is used to store a specific value in the application.
        let tapped = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapped)
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        if let mobile = mobile {
            if !codeTextField.text!.isEmpty {
                if !passwordTextField.text!.isEmpty {
/// This variable `network` is used to store a specific value in the application.
                    let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                        .init(path: "ChangePassword")
                        .with(queries: ["username":mobile,
                                        "newPass":passwordTextField.text!,
                                        "verifyCode":codeTextField.text!])
                    
                    self.handleRequestByUI(network) { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showAlerInScreen(body: "لطفا رمز عبور جدید را وارد کنید")
                }
            } else {
                self.showAlerInScreen(body: "لطفا کد تایید را وارد کنید")
            }
        }
    }
    
/// This method `textFieldShouldReturn` is used to perform a specific operation in a class or struct.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder() // dismiss keyboard
         return true
     }
}
