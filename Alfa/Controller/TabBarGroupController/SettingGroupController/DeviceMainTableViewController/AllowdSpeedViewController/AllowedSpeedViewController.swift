//
//  AllowedSpeedViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit
import MessageUI

/// This class `AllowedSpeedViewController` is used to manage specific logic in the application.
class AllowedSpeedViewController: BaseViewController {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var kmpTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        kmpTextField.keyboardType = .asciiCapableNumberPad
        kmpTextField.becomeFirstResponder()
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            kmpTextField.text = defaultDevice.km
        }
    }
    
    @objc func tapped() {
        dismiss(animated: true)
    }

    @IBAction func doneTapped(_ sender: Any) {
        if !kmpTextField.text!.isEmpty {
            if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `pass` is used to store a specific value in the application.
                let pass = defaultDevice.car.devicePass
/// This variable `speed` is used to store a specific value in the application.
                let speed = kmpTextField.text!
/// This variable `final` is used to store a specific value in the application.
                var final = ""
                if let speedInt = Int(speed) {
                    if speedInt < 10 {
                        final = "00\(speed)"
                    } else if speedInt < 100 {
                        final = "0\(speed)"
                    } else if speedInt <= 0 {
                        final = "000"
                    }
                }
                self.sendMessage(body: "speed\(pass) \(final)", phone: defaultDevice.car.phone)
            }
        } else {
            self.showAlerInScreen(body: "لطفا سرعت را وارد کنید")
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `pass` is used to store a specific value in the application.
            let pass = defaultDevice.car.devicePass
            
            self.sendMessage(body: "nospeed\(pass)", phone: defaultDevice.car.phone)
        }
    }
}


extension AllowedSpeedViewController: MFMessageComposeViewControllerDelegate {
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if let controller = controller as? CustomMFMessageComposeViewControllerDelegate {
/// This variable `tag` is used to store a specific value in the application.
            let tag = controller.tag

            switch result {
            case .sent:
                if var defaultDevice = DeviceLocalSetting.defaultItem {
                    defaultDevice.km = kmpTextField.text!
                    DeviceLocalSetting.update(item: defaultDevice)
                }
            default: break
            }
            
            controller.dismiss(animated: true) { [weak self] in
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
