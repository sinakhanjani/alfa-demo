//
//  SenseDeviceViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit
import MessageUI

/// This class `SenseDeviceViewController` is used to manage specific logic in the application.
class SenseDeviceViewController: BaseViewController {
    @IBOutlet weak var senseSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            senseSlider.setValue(Float(defaultDevice.sens), animated: false)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func senseSliderValueChanged(_ sender: UISlider) {
        if sender.value < 0.7 {
            sender.value = 0
        }
        if sender.value >= 0.7 && sender.value < 1.7 {
            sender.value = 1
        }
        if sender.value >= 1.7 {
            sender.value = 2
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `pass` is used to store a specific value in the application.
            let pass = defaultDevice.car.devicePass
            self.sendMessage(body: "sensitivity\(pass) \(Int(senseSlider.value))", phone: defaultDevice.car.phone)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension SenseDeviceViewController: MFMessageComposeViewControllerDelegate {
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if let controller = controller as? CustomMFMessageComposeViewControllerDelegate {
//            let tag = controller.tag

            switch result {
            case .sent:
                if var defaultDevice = DeviceLocalSetting.defaultItem {
                    defaultDevice.sens = Int(senseSlider.value)
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
