//
//  AddDeviceViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit
import SimpleCheckbox
import RestfulAPI
import MessageUI

/// This class `AddDeviceViewController` is used to manage specific logic in the application.
class AddDeviceViewController: BaseViewController {
    
/// This variable `completion` is used to store a specific value in the application.
    var completion: ((_ status: Bool) -> Void)?

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var deviceTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
    @IBOutlet weak var defaultSettingCheckBox: Checkbox!
    
/// This variable `phone` is used to store a specific value in the application.
    var phone: String?
/// This variable `deviceName` is used to store a specific value in the application.
    var deviceName: String?
/// This variable `serial` is used to store a specific value in the application.
    var serial: String?
    
/// This variable `devicePass` is used to store a specific value in the application.
    let devicePass = "123456"
/// This variable `step2` is used to store a specific value in the application.
    var step2 = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettingCheckBox.isChecked = true
        phoneTextField.keyboardType = .asciiCapableNumberPad
        
        if let phone = phone {
            self.phoneTextField.text = phone
        }
        if let deviceName = deviceName {
            self.deviceTextField.text = deviceName
        }
        if let serial = serial {
            self.serialTextField.text = serial
        }
        
        self.phoneTextField.becomeFirstResponder()
    }
    
    @IBAction func doneTapped() {
        if !self.phoneTextField.text!.isEmpty && !self.deviceTextField.text!.isEmpty && !self.serialTextField.text!.isEmpty {
            if defaultSettingCheckBox.isChecked {
                self.fetchDefeaultAddType {[weak self] server in
                    guard let self = self else { return }
                    if let server = server, let addType = server.addressType {
/// This variable `dns` is used to store a specific value in the application.
                        let dns = server.dns ?? ""
/// This variable `ip` is used to store a specific value in the application.
                        let ip = server.ip ?? ""
                        
                        if addType == "dns" {
                            self.step2 = "DNS" + self.devicePass + " " + dns + " " + "9000"
                        } else {
                            self.step2 = "adminip" + self.devicePass + " " + ip + " " + "9000"
                        }
                        
                        self.sendMessage(body: "time zone\(self.devicePass) 3.5", phone: self.phoneTextField.text!, tag: "step1")
                    }
                }
            } else {
                self.addReq(imei: self.serialTextField.text!, deviceName: self.deviceTextField.text!, phone: self.phoneTextField.text!)
            }
        } else {
            self.showAlerInScreen(body: "لطفا تمامی فیلد‌ها را تکمیل نمایید")
        }
    }
    
    @IBAction func cancelTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.completion?(false)
        }
    }
}

extension AddDeviceViewController {
/// This method `addReq` is used to perform a specific operation in a class or struct.
    func addReq(imei: String, deviceName: String, phone: String) {
        if let account = Account.decode(directory: Account.archiveURL), let username = account.username {
            self.validate(imei: imei) { [weak self] type in
                guard let self = self else { return }
                
                if let type = type {
/// This variable `network` is used to store a specific value in the application.
                    let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                        .init(path: "AddDevice")
                        .with(auth: .auth1)
                        .with(method: .POST)
                        .with(queries: ["imei":imei,
                                        "gpsType":type,
                                        "name":deviceName,
                                        "userName":username,
                                        "phone":phone,
                                        "device_pass":self.devicePass])
                    
                    self.handleRequestByUI(network, animated: true) {[weak self] object in
                        self?.dismiss(animated: true) { [weak self] in
                            self?.completion?(true)
                        }
                    }
                } else {
                    self.showAlerInScreen(body: "سریال دستگاه معتبر نمیباشد")
                }
            }
        }
    }
    
/// This method `validate` is used to perform a specific operation in a class or struct.
    func validate(imei: String, completion: @escaping (_ type: String?) -> Void) {
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<Validate>>
            .init(path: "isAlfa")
            .with(auth: .auth1)
            .with(queries: ["imei":imei])
        
        self.handleRequestByUI(network, animated: true) { validate in
            if let validate = validate, validate.type != 100 {
                completion(String(validate.type))
            } else {
                completion(nil)
            }
        }
    }
    
/// This method `fetchDefeaultAddType` is used to perform a specific operation in a class or struct.
    func fetchDefeaultAddType(completion: @escaping (_ type: Server?) -> Void) {
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<Server>>
            .init(path: "GetDefaultServer")
            
        handleRequestByUI(network, animated: true) { server in
            if let server = server {
                completion(server)
            } else {
                completion(nil)
            }
        }
    }
}


extension AddDeviceViewController: MFMessageComposeViewControllerDelegate {
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true)
        case .sent:
            if let controller = controller as? CustomMFMessageComposeViewControllerDelegate {
/// This variable `tag` is used to store a specific value in the application.
                let tag = controller.tag
                guard !phoneTextField.text!.isEmpty else {
                    self.showAlerInScreen(body: "تلفن همراه را وارد کنید")
                    return
                }
                
                controller.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    switch tag {
                    case "step1":
                        self.sendMessage(body: self.step2, phone: self.phoneTextField.text!, tag: "step2")
                    case "step2":
                        self.sendMessage(body: "gprs\(self.devicePass)", phone: self.phoneTextField.text!, tag: "step3")
                    case "step3":
                        self.sendMessage(body: "protocol\(self.devicePass) 18 out", phone: self.phoneTextField.text!, tag: "step4")
                    case "step4":
                        self.sendMessage(body: "fix020s060m***n\(self.devicePass)", phone: self.phoneTextField.text!, tag: "step5")
                    case "step5":
                        if !self.phoneTextField.text!.isEmpty && !self.deviceTextField.text!.isEmpty && !self.serialTextField.text!.isEmpty {
                            self.addReq(imei: self.serialTextField.text!, deviceName: self.deviceTextField.text!, phone: self.phoneTextField.text!)
                        } else {
                            self.showAlerInScreen(body: "لطفا تمامی فیلد‌ها را تکمیل نمایید")
                        }
                        break
                    default:
                        break
                    }
                }
            }
        case .failed:
            controller.dismiss(animated: true)
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



// identity imei
// send 5 sms ( 2halat addressType: dns ya ip
// send add Req

// agar tanzim avali nadasht 5ta sms nadairm.

// MARK: - DataClass
/// This class `Validate` is used to manage specific logic in the application.
struct Validate: Codable {
/// This variable `id` is used to store a specific value in the application.
    let id: Int?
/// This variable `imei` is used to store a specific value in the application.
    let imei: String?
/// This variable `type` is used to store a specific value in the application.
    let type: Int
/// This variable `simcard,` is used to store a specific value in the application.
    let simcard, owner: String?
/// This variable `bar,` is used to store a specific value in the application.
    let bar, sitestatus: Int?
}
