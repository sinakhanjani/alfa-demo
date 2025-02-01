//
//  RemoteTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/19/1401 AP.
//

import UIKit
import DropDown
import RestfulAPI
import MessageUI

/// This class `RemoteTableViewController` is used to manage specific logic in the application.
class RemoteTableViewController: BaseTableViewController {
    
    @IBOutlet weak var remoteImageView: UIImageView!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var dropDown: DropDown!
    
/// This variable `refDropDown` is used to store a specific value in the application.
    var refDropDown: DropDown?
/// This variable `lockAudioPlayer` is used to store a specific value in the application.
    var lockAudioPlayer: AudioPlayer? = AudioPlayer(title: "car_lock_sound_effect")
/// This variable `unlockAudioPlayer` is used to store a specific value in the application.
    var unlockAudioPlayer: AudioPlayer? = AudioPlayer(title: "car_unlock_sound_effect")

/// This variable `defaultDeviceID` is used to store a specific value in the application.
    var defaultDeviceID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refDropDown = dropDown
        
        dropDown.dataSource = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        dropDown.reloadAllComponents()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[index]
            self?.carButton.setTitle(item, for: .normal)
            self?.remoteImageView.image = DeviceLocalSetting.get()[index].isSwitchOn ? UIImage(named: "img_remote_on"):UIImage(named: "img_remote_off")

/// This variable `gpsType` is used to store a specific value in the application.
            let gpsType = DeviceLocalSetting.get()[index].car.gpsType
            if gpsType == "601" || gpsType == "705" || gpsType == "704" {
                self?.tabBarController?.selectedIndex = 2
                self?.tabBarController?.viewControllers?.removeLast()
            }
            
            NotificationCenter.default.post(name: .defaultDeviceChanged, object: nil)
        }
        
        dropDown.width = UIScreen.main.bounds.width-32
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceFetched), name: .deviceFetched, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // config by default
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            carButton.setTitle(defaultDevice.car.deviceName, for: .normal)
            self.remoteImageView.image = defaultDevice.isSwitchOn ? UIImage(named: "img_remote_on"):UIImage(named: "img_remote_off")
        }
    }
    
    @objc func deviceFetched() {
        dropDown.dataSource = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        dropDown.reloadAllComponents()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func lockButtonTapped(_ sender: UIButton) {
        if let defaualtDevice = DeviceLocalSetting.defaultItem {
/// This variable `mode` is used to store a specific value in the application.
            let mode = 2
            if case .online(_) = connetctionStatus {
                if defaualtDevice.sendSMS {
                    // sms*
                    self.sendMessage(body: "arm\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "lock")
                } else {
                    self.sendReq(mode: mode, imei: defaualtDevice.car.imei) { [weak self] in
                        self?.lockAudioPlayer?.start()
                    }
                }
            } else {
                self.sendMessage(body: "arm\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "lock")
            }
        }
    }
    
    @IBAction func unlockButtonTapped(_ sender: UIButton) {
        if let defaualtDevice = DeviceLocalSetting.defaultItem {
/// This variable `mode` is used to store a specific value in the application.
            let mode = 1
            if case .online(_) = connetctionStatus {
                if defaualtDevice.sendSMS {
                    // sms*
                    self.sendMessage(body: "disarm\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "unlock")
                } else {
                    self.sendReq(mode: mode, imei: defaualtDevice.car.imei) { [weak self] in
                        self?.unlockAudioPlayer?.start()
                    }
                }
            } else {
                self.sendMessage(body: "disarm\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "unlock")
            }
        }
    }
    
    @IBAction func onAndOffButtonTapped(_ sender: UIButton) {
        if let defaualtDevice = DeviceLocalSetting.defaultItem {
/// This variable `alertVC` is used to store a specific value in the application.
            let alertVC = AlertContentViewController
                .instantiate()
                .alert(AlertContent(title: .none, subject: "", description: "آیا تمایل به توفق خودرو دارید، اینکار ممکن است خطرناک باشد"))
            
            if case .online(_) = connetctionStatus {
/// This variable `mode` is used to store a specific value in the application.
                let mode = defaualtDevice.isSwitchOn ? 3:4
                
                if defaualtDevice.sendSMS {
                    // send message on or off *
                    if defaualtDevice.isSwitchOn {
                        alertVC.yesButtonTappedHandler = { [weak self] in
                            self?.sendMessage(body: "stop\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "stop")
                        }
                        self.present(alertVC)
                    } else {
                        self.sendMessage(body: "resume\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "resume")
                    }
                } else {
                    if defaualtDevice.isSwitchOn {
                        alertVC.yesButtonTappedHandler = { [weak self] in
                            self?.sendReq(mode: mode, imei: defaualtDevice.car.imei) { [weak self] in
                                self?.remoteImageView.image = defaualtDevice.isSwitchOn ? UIImage(named: "img_remote_on"):UIImage(named: "img_remote_off")
                            }
                        }
                        self.present(alertVC)
                    } else {
                        self.sendReq(mode: mode, imei: defaualtDevice.car.imei) { [weak self] in
                            self?.remoteImageView.image = defaualtDevice.isSwitchOn ? UIImage(named: "img_remote_on"):UIImage(named: "img_remote_off")
                        }
                    }
                }
            } else {
                // send message on or off *
                if defaualtDevice.isSwitchOn {
                    alertVC.yesButtonTappedHandler = { [weak self] in
                        self?.sendMessage(body: "stop\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "stop")
                    }
                    self.present(alertVC)
                } else {
                    self.sendMessage(body: "resume\(defaualtDevice.car.devicePass)", phone: defaualtDevice.car.phone, tag: "resume")
                }
            }
        }
    }
}

extension RemoteTableViewController {
/// This method `sendReq` is used to perform a specific operation in a class or struct.
    func sendReq(mode: Int, imei: String, completion: (() -> Void)? = nil) {
        /*
         1: باز کردن
         2: بستن
         3: لغو خاموشی
         4: خاموشی
         */
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
            .init(path: "GprsCommand")
            .with(auth: .auth1)
            .with(queries: ["imei":imei,
                            "commandCode":"\(mode)"])
        self.handleRequestByUI(network, animated: true) {[weak self] _ in
            self?.animate()
            completion?()
        }
    }
}

extension RemoteTableViewController {
/// This method `animate` is used to perform a specific operation in a class or struct.
    func animate() {
/// This variable `isOn` is used to store a specific value in the application.
        var isOn = false
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.carImageView.image = isOn ? UIImage(named: "img_top_remote_on"):UIImage(named: "img_top_remote")
            isOn.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
            self.carImageView.image = isOn ? UIImage(named: "img_top_remote_on"):UIImage(named: "img_top_remote")
            isOn.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
            self.carImageView.image = isOn ? UIImage(named: "img_top_remote_on"):UIImage(named: "img_top_remote")
            isOn.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.6) {
            self.carImageView.image = isOn ? UIImage(named: "img_top_remote_on"):UIImage(named: "img_top_remote")
            isOn.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            self.carImageView.image = isOn ? UIImage(named: "img_top_remote_on"):UIImage(named: "img_top_remote")
            isOn.toggle()
        }
    }
}

extension RemoteTableViewController: MFMessageComposeViewControllerDelegate {
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if let controller = controller as? CustomMFMessageComposeViewControllerDelegate {
/// This variable `tag` is used to store a specific value in the application.
            let tag = controller.tag
            
            switch result {
            case .sent:
                switch tag {
                case "resume":
                    remoteImageView.image = UIImage(named: "img_remote_off")
                    if var defaualtDevice = DeviceLocalSetting.defaultItem {
                        defaualtDevice.isSwitchOn = true
                        DeviceLocalSetting.update(item: defaualtDevice)
                    }
                case "stop":
                    remoteImageView.image = UIImage(named: "img_remote_on")
                    if var defaualtDevice = DeviceLocalSetting.defaultItem {
                        defaualtDevice.isSwitchOn = false
                        DeviceLocalSetting.update(item: defaualtDevice)
                    }
                case "lock":
                    self.lockAudioPlayer?.start()
                case "unlock":
                    self.unlockAudioPlayer?.start()
                default:
                    break
                }

            default: break
            }
            
            controller.dismiss(animated: true)
            
            self.animate()
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



/// This class `CustomMFMessageComposeViewControllerDelegate` is used to manage specific logic in the application.
class CustomMFMessageComposeViewControllerDelegate: MFMessageComposeViewController {
/// This variable `tag` is used to store a specific value in the application.
    var tag: String = ""
}
