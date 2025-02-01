//
//  AddLinkViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 7/19/22.
//

import UIKit
import DropDown
import RestfulAPI

/// This class `AddLinkViewController` is used to manage specific logic in the application.
class AddLinkViewController: BaseViewController {
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var modelView: UIView!
    @IBOutlet weak var dropDown: DropDown!

/// This variable `completion` is used to store a specific value in the application.
    var completion: ((_ status: Bool) -> Void)?
/// This variable `eshterak` is used to store a specific value in the application.
    var eshterak: Eshterak?
/// This variable `refDropDown` is used to store a specific value in the application.
    var refDropDown: DropDown?

    override func viewDidLoad() {
        super.viewDidLoad()
        timeDatePicker.locale = Locale(identifier: "fa_IR")
        timeDatePicker.calendar = Calendar(identifier: .persian)
        
        dateDatePicker.locale = Locale(identifier: "fa_IR")
        dateDatePicker.calendar = Calendar(identifier: .persian)
        
        refDropDown = dropDown
        
        dropDown.dataSource = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        dropDown.reloadAllComponents()
        
        dropDown.dataSource = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        dropDown.reloadAllComponents()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.carButton.setTitle(item, for: .normal)
        }
        
        dropDown.width = UIScreen.main.bounds.width-32
        
        if let eshterak = eshterak {
            self.modelView.alpha = 0
            if let date = eshterak.expireDate?.toDateX(format: "yyyy-MM-dd'T'HH:mm:ss") {
                self.dateDatePicker.date = date
                self.timeDatePicker.date = date
            }
        } else {
            self.modelView.alpha = 1
        }
    }
    
/// This method `addReq` is used to perform a specific operation in a class or struct.
    func addReq(eshterak: Eshterak? = nil) {
        // send req and get urlLINK
        if let account = Account.decode(directory: Account.archiveURL), let username = account.username {
            if let defualtDevice = DeviceLocalSetting.defaultItem {
/// This variable `date1` is used to store a specific value in the application.
                let date1 = dateDatePicker.date.toStringEn(format: "yyyy-MM-dd")
/// This variable `time` is used to store a specific value in the application.
                let time = timeDatePicker.date.toStringEn(format: "HH:mm")
/// This variable `date` is used to store a specific value in the application.
                let date = "\(date1)T\(time):00"
                
/// This variable `queries` is used to store a specific value in the application.
                var queries: Queries = ["username":username,
                                        "imei":defualtDevice.car.imei,
                                        "expireDate": date,
                                        "urlLink":"",
            //                            "id":""
                                       ]
                
/// This variable `str` is used to store a specific value in the application.
                var str = ""
                
                if let id = eshterak?.id {
                    queries.updateValue("\(id)", forKey: "id")
                    str = "Link_Update"
                    if let url = eshterak?.urlLink {
                        queries.updateValue(url, forKey: "urlLink")
                    }
                } else {
                    str = "Link_add"
                }
                
/// This variable `network` is used to store a specific value in the application.
                let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                    .init(path: str)
                    .with(auth: .auth1)
                    .with(queries: queries)
                
                self.handleRequestByUI(network, animated: true) {[weak self] _ in
                    self?.dismiss(animated: true) { [weak self] in
                        self?.completion?(true)
                    }
                }
            }
        }
    }
    
    @IBAction func carButtonTapped(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if let eshterak = eshterak {
            addReq(eshterak: eshterak)
        } else {
            addReq()
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.completion?(false)
        }
    }
}
