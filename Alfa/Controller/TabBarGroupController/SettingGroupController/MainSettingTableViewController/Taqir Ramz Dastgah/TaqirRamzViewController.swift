//
//  TaqirRamzViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/28/1401 AP.
//

import UIKit
import RestfulAPI

/// This class `TaqirRamzViewController` is used to manage specific logic in the application.
class TaqirRamzViewController: BaseViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var reEnterPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var oldPassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            self.oldPassTextField.text = defaultDevice.car.devicePass
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            if newPassTextField.text == reEnterPassTextField.text {
                if !newPassTextField.text!.isEmpty {
                    if oldPassTextField.text! == defaultDevice.car.devicePass {
/// This variable `network` is used to store a specific value in the application.
                        let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                            .init(path: "AddDevice")
                            .with(auth: .auth1)
                            .with(method: .POST)
                            .with(queries: ["imei":defaultDevice.car.imei,
                                            "gpsType":defaultDevice.car.gpsType,
                                            "name":defaultDevice.car.deviceName!,
                                            "userName":defaultDevice.car.userName!,
                                            "phone":defaultDevice.car.phone,
                                            "device_pass":newPassTextField.text!])
                        
                        self.handleRequestByUI(network, animated: true) {[weak self] object in
                            self?.fetchDevice()
                        }
                    } else {
                        self.showAlerInScreen(body: "رمز عبور قدیم اشتباه است")
                    }
                } else {
                    self.showAlerInScreen(body: "لطفا پسورد را وارد کنید")
                }
            } else {
                self.showAlerInScreen(body: "رمز عبور یکسان نیست")
            }
        } else {
            self.showAlerInScreen(body: "دستگاه موجود نمیباشد.")
        }
    }
    
/// This method `fetchDevice` is used to perform a specific operation in a class or struct.
    func fetchDevice() {
        if let account = Account.decode(directory: Account.archiveURL), let username = account.username {
/// This variable `network` is used to store a specific value in the application.
            let network = RestfulAPI<EMPTYMODEL,GenericModel<[Car]>>
                .init(path: "KarbarGet")
                .with(queries: ["username": username,
                                "Password": Setting.passworrd!,
                                "androidId": UIApplication.appBuild,
                                "model": UIApplication.deviceName,
                                "appVersion": UIApplication.appBuild])
                .with(auth: .auth1)
            
            handleRequestByUI(network, animated: true) { [weak self] items in
                if let items = items {
                    DeviceLocalSetting.insert(cars: items)
                    
                    NotificationCenter.default.post(name: .deviceFetched, object: nil)
                    self?.dismiss(animated: true)
                }
            }
        }
    }
}
