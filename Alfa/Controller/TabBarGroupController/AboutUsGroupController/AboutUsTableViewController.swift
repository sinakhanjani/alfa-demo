//
//  AboutUsTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/19/1401 AP.
//

import UIKit
import RestfulAPI

/// This class `AboutUsTableViewController` is used to manage specific logic in the application.
class AboutUsTableViewController: BaseTableViewController {
    
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var learButton: UIButton!
    @IBOutlet weak var telegramButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var telegram2Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if case .online(_) = connetctionStatus {
            fetchDevice()
            fetchV()
        } else {
            if let infos = Info.decode(directory: Info.archiveURL) {
                self.updateElements(items: infos)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if case .online(_) = connetctionStatus {
            
        } else {
            navigate()
        }
        
    }
    
/// This method `navigate` is used to perform a specific operation in a class or struct.
    func navigate() {
        if let tabBarController = self.tabBarController {
            if let nav = tabBarController.viewControllers?.last as? UINavigationController, let _ = nav.viewControllers.first as? RemoteTableViewController {
                // do nothing
            } else {
                if let firstItem = DeviceLocalSetting.defaultItem {
/// This variable `gpsType` is used to store a specific value in the application.
                    let gpsType = firstItem.car.gpsType
                    if gpsType != "601" && gpsType != "705" && gpsType != "704" {
/// This variable `nav` is used to store a specific value in the application.
                        let nav = UINavigationController.instantiate()
/// This variable `remoteVC` is used to store a specific value in the application.
                        let remoteVC = RemoteTableViewController.instantiate()
                        nav.setViewControllers([remoteVC], animated: true)
                        tabBarController.viewControllers?.append(nav)
                        tabBarController.selectedIndex = 3
                    } else {
                        tabBarController.selectedIndex = 2
                    }
                } else {
                    tabBarController.selectedIndex = 2
                }
            }
        }
    }
    
/// This method `updateElements` is used to perform a specific operation in a class or struct.
    func updateElements(items: [Info]) {
/// This method `find` is used to perform a specific operation in a class or struct.
        func find(tag: String) -> String? {
            return items.first(where: { info in
                info.parameterName == tag
            })?.parameterValue
        }
        
        if let webURL = find(tag: "contact_website") {
            self.webButton.setTitle(webURL, for: .normal)
        }
        if let learn = find(tag: "contact_amozesh") {
            self.learButton.setTitle(learn, for: .normal)
        }
        if let contact_telegramChannel = find(tag: "contact_telegramChannel") {
            self.telegramButton.setTitle(contact_telegramChannel, for: .normal)
        }
        if let whatsapp = find(tag: "contact_whatsapp") {
            self.whatsappButton.setTitle(whatsapp, for: .normal)
        }
        if let call = find(tag: "contact_call") {
            self.callButton.setTitle(call, for: .normal)
        }
        if let contact_telegram = find(tag: "contact_telegram") {
            self.telegram2Button.setTitle(contact_telegram, for: .normal)
        }

    }
    
/// This method `noData` is used to perform a specific operation in a class or struct.
    func noData(deviceLocalSettings: [DeviceLocalSetting]) {
/// This variable `names` is used to store a specific value in the application.
        var names = ""

        deviceLocalSettings.forEach { deviceLocalSetting in
            if let lastDate = deviceLocalSetting.car.lastZaman?.toDate() {
/// This variable `delta` is used to store a specific value in the application.
                let delta = lastDate - Date()
/// This variable `hourDelta` is used to store a specific value in the application.
                let hourDelta = (delta/60)/60
                if -hourDelta >= 2 {
                    if let i = deviceLocalSetting.car.deviceName {
                        if names.isEmpty {
                            names = i
                        } else {
                            names = names + ", " + i
                        }
                    }
                }
            }
        }

        if names != "" {
/// This variable `message` is used to store a specific value in the application.
            let message = "دستگاه \(names) بیش از دو ساعت است که دیتایی ارسال نکرده‌اند"
/// This variable `alertVC` is used to store a specific value in the application.
            let alertVC = AlertContentViewController.instantiate()
                .alert(AlertContent(title: .none, subject: "هشدار", description: message))
                .buttonTitle(yesTitle: "تایید", noTitle: "بستن")

            self.present(alertVC, animated: true)
        }
    }
    
/// This method `subs` is used to perform a specific operation in a class or struct.
    func subs(deviceLocalSettings: [DeviceLocalSetting]) {
        deviceLocalSettings.forEach { deviceLocalSetting in
            if let remaining = deviceLocalSetting.car.remainDays {
                if remaining < 7 {
/// This variable `message` is used to store a specific value in the application.
                    let message = "اشتراک شما به اتمام رسیده است، لطفا آن را تمدید کنید"
/// This variable `alertVC` is used to store a specific value in the application.
                    let alertVC = AlertContentViewController.instantiate()
                        .alert(AlertContent(title: .none, subject: "هشدار", description: message))
                        .buttonTitle(yesTitle: "تمدید", noTitle: "بستن")

                    alertVC.yesButtonTappedHandler = {
                        if let account = Account.decode(directory: Account.archiveURL), let username = account.username, let password = Setting.passworrd {
/// This variable `network` is used to store a specific value in the application.
                            let network = RestfulAPI<EMPTYMODEL,GenericModel<String>>
                                .init(path: "GetLoginLink")
                                .with(auth: .auth1)
                                .with(queries: ["username":username,
                                                "password":password])
                            
                            self.handleRequestByUI(network) { data in
                                if let data = data {
                                    URL.open(urlString: data)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.6) {
                        self.present(alertVC, animated: true)
                    }
                    
                    return
                }
            }
        }

    }
    
    @IBAction func webTapped(_ sender: Any) {
        URL.open(urlString: webButton.titleLabel!.text!)
    }
    
    @IBAction func telegramTapped(_ sender: UIButton) {
        URL.open(urlString: telegramButton.titleLabel!.text!)
    }
    
    @IBAction func learnTapped(_ sender: Any) {
        URL.open(urlString: learButton.titleLabel!.text!)
    }
    
    @IBAction func telegram2Tapped(_ sender: Any) {
        URL.open(urlString: telegram2Button.titleLabel!.text!)

    }
    
    @IBAction func whatsappTapped(_ sender: Any) {
        whatsappButton.titleLabel!.text!.makeACall()
    }
    
    @IBAction func callTapped(_ sender: Any) {
        callButton.titleLabel?.text!.makeACall()
    }
}

public extension URL {
    static func open(urlString: String) {
        if urlString.contains("http") || urlString.contains("https") {
/// This variable `detectedURL` is used to store a specific value in the application.
            let detectedURL = URL(string: urlString)
            if let url = detectedURL {
              UIApplication.shared.open(url, options: [:], completionHandler: { success in print(url, "\n", success) })
            }
        } else {
/// This variable `escapedString` is used to store a specific value in the application.
            let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
/// This variable `logeionURL` is used to store a specific value in the application.
            let logeionURL = URL(string: "https://"+escapedString)
            if let url = logeionURL {
              UIApplication.shared.open(url, options: [:], completionHandler: { success in print(url, "\n", success) })
            }
        }
    }
}


// MARK: - Info
/// This class `Info` is used to manage specific logic in the application.
struct Info: Codable {
    static public var archiveURL: URL {
/// This variable `documentsDirectory` is used to store a specific value in the application.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("information").appendingPathExtension("inf")
    }
    
    static func encode(userInfo: [Info], directory dir: URL) {
/// This variable `propertyListEncoder` is used to store a specific value in the application.
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> [Info]? {
/// This variable `propertyListDecoder` is used to store a specific value in the application.
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode([Info].self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
    
/// This variable `version` is used to store a specific value in the application.
    let version: Int?
/// This variable `name` is used to store a specific value in the application.
    let name: String?
/// This variable `parameterName` is used to store a specific value in the application.
    let parameterName: String?
/// This variable `parameterValue` is used to store a specific value in the application.
    let parameterValue: String?
/// This variable `parameterID` is used to store a specific value in the application.
    let parameterID: Int?

    enum CodingKeys: String, CodingKey {
        case version, name, parameterName, parameterValue
        case parameterID = "parameterId"
    }
}

extension AboutUsTableViewController {
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
            
            handleRequestByUI(network) { [weak self] items in
                if let items = items {
                    DeviceLocalSetting.insert(cars: items)

                    Setting.chached = true
                    // set luanch default index
                    if let firstItem = DeviceLocalSetting.get().first, let index = firstItem.car.defaultDeviceID {
/// This variable `all` is used to store a specific value in the application.
                        let all = DeviceLocalSetting.get()
                        
                        self?.noData(deviceLocalSettings: all)
                        self?.subs(deviceLocalSettings: all)
                        
                        DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[index]
                    }
                    
                    self?.navigate()
                    
                    NotificationCenter.default.post(name: .deviceFetched, object: nil)
                }
            }
        }
    }
    
/// This method `fetchV` is used to perform a specific operation in a class or struct.
    func fetchV() {
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<[Info]>>
            .init(path: "GetAppParameters")
            .with(auth: .auth1)
            .with(queries: ["appName":"remote"])
        self.handleRequestByUI(network) { infos in
            if let infos = infos {
                Info.encode(userInfo: infos, directory: Info.archiveURL)
                self.updateElements(items: infos)
                if let first = infos.first, let v = first.version {
                    if let appBuild = Int(UIApplication.appBuild) {
                        if appBuild < v {
/// This variable `vc` is used to store a specific value in the application.
                            let vc = WarningContentViewController.instantiate()
                                .alert(AlertContent(title: .none, subject: "به روز رسانی", description: "ورژن جدید اپلیکیشن موجود میباشد، لطفا آن را از استور خود به روز رسانی کنید"))
                            self.present(vc)
                        }
                    }
                }
            }
        }
    }

}
