//
//  LoginViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/18/1401 AP.
//

import UIKit
import SimpleCheckbox
import RestfulAPI

/// This class `LoginViewController` is used to manage specific logic in the application.
class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var checkBox: Checkbox!

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self // set delegate
        passwordTextField.delegate = self // set delegate
        phoneTextField.keyboardType = .asciiCapableNumberPad
        
/// This variable `tapped` is used to store a specific value in the application.
        let tapped = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapped)
        checkBox.valueChanged = { status in

        }
        
        if let account = Account.decode(directory: Account.archiveURL) {
            if Setting.savePassword {
                self.phoneTextField.text = account.username
                if let password = Setting.passworrd {
                    self.passwordTextField.text = password
                    self.checkBox.isChecked = true
                }
            } else {
                self.phoneTextField.text = account.username
            }
        }
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        if !phoneTextField.text!.isEmpty {
/// This variable `network` is used to store a specific value in the application.
            let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                .init(path: "User_RequestPass")
                .with(queries: ["username":phoneTextField.text!])
            self.handleRequestByUI(network, animated: true) { [weak self] _ in
                guard let self = self else { return }
/// This variable `vc` is used to store a specific value in the application.
                let vc = ForgotPasswordViewController
                    .instantiate()
                vc.mobile = self.phoneTextField.text
                self.show(vc
                          , sender: nil)
            }
        } else {
            self.showAlerInScreen(body: "لطفا شماره موبایل را وارد کنید")
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if !phoneTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            if case .online(_) = connetctionStatus {
/// This variable `network` is used to store a specific value in the application.
                let network = RestfulAPI<EMPTYMODEL,GenericModel<Account>>
                    .init(path: "login")
                    .with(queries: ["username":phoneTextField.text!,
                                    "pass":passwordTextField.text!])
                    .with(method: .POST)
                
                self.handleRequestByUI(network, animated: true) {[weak self] account in
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
                        self?.present(tab)
                        Setting.savePassword = self?.checkBox.isChecked ?? false
                        Setting.passworrd = self?.passwordTextField.text
                        // change server
                        if let server = account.server, let baseURL = server.api {
                            Setting.changeBaseURL(to: baseURL)
                        }
                    }
                }
            } else {
                if Setting.chached {
/// This variable `alertVC` is used to store a specific value in the application.
                    let alertVC = AlertContentViewController
                        .instantiate()
                        .alert(AlertContent(title: .none, subject: "قطعی اینترنت", description: "اینترنت شما قطع شده است، ایا میخواهید به صورت آفلاین ادامه دهید؟"))
                        .buttonTitle(yesTitle: "بله", noTitle: "خیر")
                    alertVC.yesButtonTappedHandler = { [weak self] in
                        Setting.savePassword = self?.checkBox.isChecked ?? false
/// This variable `tab` is used to store a specific value in the application.
                        let tab = UITabBarController
                            .instantiate()
                        self?.present(tab)
                    }
                    
                    present(alertVC)
                } else {
                    showAlerInScreen(body: "اینترنت شما قطع میباشد، لطفا اینترنت خود را بررسی کنید")
                }
            }
        } else {
            self.showAlerInScreen(body: "شماره موبایل و رمز عبور را وارد کنید")
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = RegisterViewController
            .instantiate()
        self.show(vc
                  , sender: nil)
    }
    
/// This method `textFieldShouldReturn` is used to perform a specific operation in a class or struct.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
}
