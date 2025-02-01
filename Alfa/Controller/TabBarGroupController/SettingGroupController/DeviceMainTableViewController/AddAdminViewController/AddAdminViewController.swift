//
//  AddAdminViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit
import MessageUI

/// This class `AddAdminViewController` is used to manage specific logic in the application.
class AddAdminViewController: BaseViewController {
/// This variable `completion` is used to store a specific value in the application.
    var completion: ((_ phone: String?) -> Void)?

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.keyboardType = .asciiCapableNumberPad
        phoneTextField.becomeFirstResponder()
        
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @objc func tapped() {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if !phoneTextField.text!.isEmpty {
/// This variable `phone` is used to store a specific value in the application.
            var phone = self.phoneTextField.text!
            if phone.hasPrefix("0") {
                phone.removeFirst()
                phone = "+98" + phone
            }
            if phone.hasPrefix("9") {
                phone = "+98" + phone
            }
        
            if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `pass` is used to store a specific value in the application.
                let pass = defaultDevice.car.devicePass
                
                self.sendMessage(body: "admin\(pass) \(phone)", phone: defaultDevice.car.phone, tag: phone)
            }
        } else {
            self.showAlerInScreen(body: "لطفا شماره همراه را وارد کنید")
        }
    }
}


extension AddAdminViewController: MFMessageComposeViewControllerDelegate {
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if let controller = controller as? CustomMFMessageComposeViewControllerDelegate {
/// This variable `tag` is used to store a specific value in the application.
            var tag = controller.tag

            controller.dismiss(animated: true) { [weak self] in
/// This variable `range` is used to store a specific value in the application.
                let range = 0...2
                tag.removeFirst()
                tag.removeFirst()
                tag.removeFirst()
                tag = "0" + tag
                self?.completion?(tag)
                self?.dismiss(animated: true)
            }
        }
    }
    
/// This method `sendMessage` is used to perform a specific operation in a class or struct.
    func sendMessage(body: String, phone: String, tag: String = "") {
        if MFMessageComposeViewController.canSendText() {
/// This variable `composeVC` is used to store a specific value in the application.
            let composeVC = CustomMFMessageComposeViewControllerDelegate()
            
            composeVC.messageComposeDelegate = self
            composeVC.recipients = [phone]
            composeVC.body = body
            composeVC.tag = tag
            
            present(composeVC, animated: true, completion: nil)
        }
    }
}
