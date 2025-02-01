//
//  RegisterViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/18/1401 AP.
//

import UIKit
import SimpleCheckbox
import RestfulAPI

/// This class `RegisterViewController` is used to manage specific logic in the application.
class RegisterViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var privacyCheckBox: Checkbox!
    @IBOutlet weak var passwordCheckBox: Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self // set delegate
        passwordTextField.delegate = self // set delegate
        phoneTextField.keyboardType = .asciiCapableNumberPad
        
/// This variable `tapped` is used to store a specific value in the application.
        let tapped = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapped)
        privacyCheckBox.valueChanged = { status in
            //
        }
        passwordCheckBox.valueChanged = { status in
            
        }
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
/// This variable `webViewVC` is used to store a specific value in the application.
        let webViewVC = WebViewViewController.instantiate()
/// This variable `url` is used to store a specific value in the application.
        var url = URL(string: "https://radyabalfa.com")!
        url.appendPathComponent("/شرایط-استفاده")
        webViewVC.url = url
        
        show(webViewVC, sender: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = LoginViewController.instantiate()
        show(vc, sender: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if !phoneTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            if phoneTextField.text!.count > 9 && phoneTextField.text!.hasPrefix("0") {
                if self.privacyCheckBox.isChecked {
/// This variable `network` is used to store a specific value in the application.
                    let network = RestfulAPI<EMPTYMODEL,GenericModel<Server>>
                        .init(path: "GetDefaultServer")
                    
                    handleRequestByUI(network, animated: true) { [weak self] server in
                        guard let self = self else { return }
                        if let server = server {
                            // change server
                            if let baseURL = server.api {
                                Setting.changeBaseURL(to: baseURL)
                            }
                            //
/// This variable `network` is used to store a specific value in the application.
                            let network = RestfulAPI<EMPTYMODEL,GenericModel<Account>>
                                .init(path: "KarbarSignUp")
                                .with(queries: ["username":self.phoneTextField.text!,
                                                "Password":self.passwordTextField.text!,
                                                "serverId":"\(server.id)"])
                                .with(method: .POST)
                            
                            self.handleRequestByUI(network, animated: true) { account in
                                if let account = account {
                                    if let token = account.token {
                                        Auth.shared.authenticate(with: token)
                                    }
                                    // encode account
                                    Account.encode(userInfo: account, directory: Account.archiveURL)
                                    // go on..
/// This variable `tab` is used to store a specific value in the application.
                                    let tab = UITabBarController
                                        .instantiate()
                                    self.present(tab)
                                    Setting.savePassword = self.passwordCheckBox.isChecked
                                    Setting.passworrd = self.passwordTextField.text
                                }
                            }
                        }
                    }
                } else {
                    self.showAlerInScreen(body: "لطفا قوانین را تایید کنید")
                }
            } else {
                self.showAlerInScreen(body: "شماره موبایل باید با صفر شروع شود و صحیح باشد!")
            }
        } else {
            self.showAlerInScreen(body: "شماره موبایل و رمز عبور را وارد کنید")
        }
    }
    
/// This method `textFieldShouldReturn` is used to perform a specific operation in a class or struct.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
