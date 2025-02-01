//
//  MainSettingTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import UIKit
import RestfulAPI
import DropDown
import MessageUI

/// This class `MainSettingTableViewController` is used to manage specific logic in the application.
class MainSettingTableViewController: BaseTableViewController {
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var dropDown: DropDown!
    
    @IBOutlet weak var dastorPayamakiSwitch: UISwitch!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var shenodSwitch: UISwitch!
    @IBOutlet weak var faceIDSwitch: UISwitch!
    
/// This variable `refDropDown` is used to store a specific value in the application.
    var refDropDown: DropDown?
    
/// This variable `devicePassword` is used to store a specific value in the application.
    let devicePassword = "123456"

    override func viewDidLoad() {
        super.viewDidLoad()
        refDropDown = dropDown
        
        dropDown.dataSource = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        dropDown.reloadAllComponents()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.carButton.setTitle(item, for: .normal)
            DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[index]
            
            self?.shenodSwitch.isOn = DeviceLocalSetting.get()[index].shenod
            self?.dastorPayamakiSwitch.isOn = DeviceLocalSetting.get()[index].sendSMS

            if (self?.shenodSwitch.isOn ?? false) {
                self?.callButton.alpha = 1
            } else {
                self?.callButton.alpha = 0
            }
            
/// This variable `gpsType` is used to store a specific value in the application.
            let gpsType = DeviceLocalSetting.get()[index].car.gpsType
            
            if gpsType == "601" || gpsType == "705" || gpsType == "704" {
                if let nav = self?.tabBarController?.viewControllers?.last as? UINavigationController, let _ = nav.viewControllers.first as? RemoteTableViewController {
                    self?.tabBarController?.viewControllers?.removeLast()
                }
            } else {
                if let nav = self?.tabBarController?.viewControllers?.last as? UINavigationController, let _ = nav.viewControllers.first as? RemoteTableViewController {
                    // do nothing
                } else {
                    // add last tab again
/// This variable `nav` is used to store a specific value in the application.
                    let nav = UINavigationController.instantiate()
/// This variable `remoteVC` is used to store a specific value in the application.
                    let remoteVC = RemoteTableViewController.instantiate()
                    nav.setViewControllers([remoteVC], animated: true)
                    self?.tabBarController?.viewControllers?.append(nav)
                }
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
            self.shenodSwitch.isOn = defaultDevice.shenod
            self.dastorPayamakiSwitch.isOn = defaultDevice.sendSMS
            
            if (self.shenodSwitch.isOn) {
                self.callButton.alpha = 1
            } else {
                self.callButton.alpha = 0
            }
            updateUIElement()
        }
    }
    
/// This method `updateUIElement` is used to perform a specific operation in a class or struct.
    func updateUIElement() {
        faceIDSwitch.isOn = Setting.isFaceIDEnable
    }
    
    @objc func deviceFetched() {
        dropDown.dataSource = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        dropDown.reloadAllComponents()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func faceIDSwitchValueChanged(_ sender: UISwitch) {
        Setting.isFaceIDEnable = sender.isOn
    }
    
    @IBAction func situCarButtonTapped(_ sender: Any) {
        if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `pass` is used to store a specific value in the application.
            let pass = defaultDevice.car.devicePass
            
            self.sendMessage(body: "check\(pass)", phone: defaultDevice.car.phone)
        }
    }
    
    @IBAction func disableSMSButtonTapped(_ sender: Any) {
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            self.sendMessage(body: "help me !", phone: defaultDevice.car.phone)
        }
    }
    
    @IBAction func listenButtonTapped(_ sender: UISwitch) {
        if sender.isOn {
            if let defaultDevice = DeviceLocalSetting.defaultItem {
                self.sendMessage(body: "monitor\(defaultDevice.car.devicePass)", phone: defaultDevice.car.phone, tag: "listen")
            }
        } else {
            if let defaultDevice = DeviceLocalSetting.defaultItem {
                self.sendMessage(body: "tracker\(defaultDevice.car.devicePass)", phone: defaultDevice.car.phone, tag: "listen")
            }
        }
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            defaultDevice.car.phone.makeACall()
        }
    }
    
    
    @IBAction func dastorPayakamiValueChanhed(_ sender: UISwitch) {
        if var defaultDevice = DeviceLocalSetting.defaultItem {
            defaultDevice.sendSMS = sender.isOn
            DeviceLocalSetting.update(item: defaultDevice)
        }
    }
}

extension MainSettingTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            // indexPath.item == 0 // device
            // indexPath.item == 1 // charge
            // indexPath.item == 2 // sensivite
            // indexPath.item == 3 // speed
            switch indexPath.item {
            case 0:
                show(DeviceMainTableViewController.instantiate(),
                     sender: true)
            case 1:
                URL.open(urlString: "https://bmi.ir/fa/pages/432/")
                break
            case 2:
/// This variable `vc` is used to store a specific value in the application.
                let vc = SenseDeviceViewController.instantiate()
                present(vc)
                break
            case 3:
/// This variable `vc` is used to store a specific value in the application.
                let vc = AllowedSpeedViewController.instantiate()
                present(vc)
                break
            default: break
            }
        }
        
        if indexPath.section == 5 {
            switch indexPath.item {
            case 0: // elan
                show(NotifTableViewController.instantiate(), sender: nil)
                break
            case 1: // list vorod
                show(ListVorodTableViewController.instantiate(), sender: nil)
                break
            case 2: // moqeyat
                break
            case 3: // taqir ramz
                present(TaqirRamzViewController.instantiate())
                break
            default: break
            }
        }
        
        if indexPath.section == 7 {
/// This variable `vc` is used to store a specific value in the application.
            let vc = AlertContentViewController.instantiate().alert(AlertContent(title: .none, subject: "", description:"آیا میخواهید از اکانت خود خارج شوید؟"))
            
            vc.yesButtonTappedHandler = {
                Auth.shared.logout()
                UIApplication.set(root: StarterViewController.instantiate())
            }
            
            self.present(vc)
        }
    }
}

extension MainSettingTableViewController: MFMessageComposeViewControllerDelegate {
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if let controller = controller as? CustomMFMessageComposeViewControllerDelegate {
/// This variable `tag` is used to store a specific value in the application.
            let tag = controller.tag
            
            if tag == "listen" {
                switch result {
                case .sent:
                    if var defaultDevice = DeviceLocalSetting.defaultItem {
                        defaultDevice.shenod = shenodSwitch.isOn
                        DeviceLocalSetting.update(item: defaultDevice)
                        if (self.shenodSwitch.isOn) {
                            self.callButton.alpha = 1
                        } else {
                            self.callButton.alpha = 0
                        }
                    }
                default:
                    self.shenodSwitch.isOn.toggle()
                    break
                }
            }
            
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
