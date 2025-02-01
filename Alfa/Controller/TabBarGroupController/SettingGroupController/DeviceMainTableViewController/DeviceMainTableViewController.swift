//
//  DeviceMainTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit
import RestfulAPI
import MessageUI

/// This class `DeviceMainTableViewController` is used to manage specific logic in the application.
class DeviceMainTableViewController: BaseTableViewController {
    
    enum Section: Hashable {
        case main
    }
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Car>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Car>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "دستگاه‌ها"
        tableViewDataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
/// This variable `cell` is used to store a specific value in the application.
            let cell = tableView.dequeueReusableCell(withIdentifier: DeviceTableViewCell.identifier, for: indexPath) as! DeviceTableViewCell
            
            if indexPath.item == itemIdentifier.defaultDeviceID {
                cell.setDefaultButton.setTitleColor(.red, for: .normal)
                cell.setDefaultButton.tintColor = .red
            } else {
                cell.setDefaultButton.setTitleColor(.AlfaBlue, for: .normal)
                cell.setDefaultButton.tintColor = .AlfaBlue
            }
            
            cell.delegate = self
            cell.config(item: itemIdentifier)
            
            return cell
        })
        
        if case .online(_) = connetctionStatus {
            fetchData()
        } else {
            // Reload snapshot
/// This variable `all` is used to store a specific value in the application.
            let all = DeviceLocalSetting.decode(directory: DeviceLocalSetting.archiveURL)
/// This variable `cars` is used to store a specific value in the application.
            let cars = all.map(\.car)
            self.snapshot = self.createSnapshot(items: cars)
            self.tableViewDataSource.apply(self.snapshot)
        }
    }
    
    private func createSnapshot(items: [Car]) -> NSDiffableDataSourceSnapshot<Section, Car> {
/// This variable `snapshot` is used to store a specific value in the application.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Car>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
    
/// This method `fetchData` is used to perform a specific operation in a class or struct.
    func fetchData(withChangeDefaultDevice: Bool = false) {
        if let account = Account.decode(directory: Account.archiveURL), let username = account.username {
/// This variable `network` is used to store a specific value in the application.
            let network = RestfulAPI<EMPTYMODEL,GenericModel<[Car]>>
                .init(path: "GetDevicesUser")
                .with(auth: .auth1)
                .with(queries: ["user":username])
            
            self.handleRequestByUI(network) {[weak self] items in
                guard let self = self else { return }
                if let items = items {
                    DeviceLocalSetting.insert(cars: items)
                    NotificationCenter.default.post(name: .deviceFetched, object: nil)
                    if withChangeDefaultDevice {
                        // set luanch default index
                        if let firstItem = DeviceLocalSetting.get().first, let index = firstItem.car.defaultDeviceID {
                            DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[index]
                        }
                    }
                    // Reload snapshot
                    self.snapshot = self.createSnapshot(items: items)
                    self.tableViewDataSource.apply(self.snapshot)
                }
            }
        }
    }
    
    @IBAction func addDeviceButtonTapped(_ sender: Any) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = AddDeviceViewController.instantiate()

        vc.completion = { [weak self] status in
            if status {
                self?.fetchData(withChangeDefaultDevice: true)
            }
        }
        
        present(vc)
    }
    
    @IBAction func allButtonTapped(_ sender: Any) {
        if let nav = tabBarController?.viewControllers?[1] as? UINavigationController {
            if let vc = nav.viewControllers.first as? MainLocationViewController {
                vc.selectedSegmentIndex = 2
                vc.selectedRow = 0
                self.tabBarController?.selectedIndex = 1
            }
        }
    }
}

extension DeviceMainTableViewController: DeviceTableViewCellDelegate {
/// This method `setDefaultDeviceButtonTapped` is used to perform a specific operation in a class or struct.
    func setDefaultDeviceButtonTapped(cell: DeviceTableViewCell, button: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let account = Account.decode(directory: Account.archiveURL), let username = account.username, let password = Setting.passworrd {
/// This variable `network` is used to store a specific value in the application.
                let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                    .init(path: "KarbarUpdate")
                    .with(auth: .auth1)
                    .with(method: .POST)
                    .with(queries: ["userName": username,
                                    "Pass": password,
                                    "validCount":"8",
                                    "active":"true",
                                    "defaultDeviceId":"\(indexPath.item)"])
                
                self.handleRequestByUI(network) {[weak self] _ in
                    guard let self = self else { return }
                    // 3.DONE
                    DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[indexPath.item]
/// This variable `gpsType` is used to store a specific value in the application.
                    let gpsType = DeviceLocalSetting.get()[indexPath.item].car.gpsType
                    
                    if gpsType == "601" || gpsType == "705" || gpsType == "704" {
                        if let nav = self.tabBarController?.viewControllers?.last as? UINavigationController, let _ = nav.viewControllers.first as? RemoteTableViewController {
                            self.tabBarController?.viewControllers?.removeLast()
                        }
                    } else {
                        if let nav = self.tabBarController?.viewControllers?.last as? UINavigationController, let _ = nav.viewControllers.first as? RemoteTableViewController {
                            // do nothing
                        } else {
                            // add last tab again
/// This variable `nav` is used to store a specific value in the application.
                            let nav = UINavigationController.instantiate()
/// This variable `remoteVC` is used to store a specific value in the application.
                            let remoteVC = RemoteTableViewController.instantiate()
                            nav.setViewControllers([remoteVC], animated: true)
                            self.tabBarController?.viewControllers?.append(nav)
                        }
                    }
                    self.showAlerInScreen(body: "تغییر دستگاه پیش‌فرض با موفقیت انجام شد")
                    self.fetchData()
                }
            }
        }
    }
    
/// This method `adminButtonTapped` is used to perform a specific operation in a class or struct.
    func adminButtonTapped(cell: DeviceTableViewCell) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = AdminListTableViewController.instantiate()
        show(vc, sender: nil)
    }
    
/// This method `showOnMapButtonTapped` is used to perform a specific operation in a class or struct.
    func showOnMapButtonTapped(cell: DeviceTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let nav = tabBarController?.viewControllers?[1] as? UINavigationController {
                if let vc = nav.viewControllers.first as? MainLocationViewController {
                    vc.selectedRow = indexPath.item+1
                    vc.selectedSegmentIndex = 2
                    DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[indexPath.item]
/// This variable `gpsType` is used to store a specific value in the application.
                    let gpsType = DeviceLocalSetting.get()[indexPath.item].car.gpsType
                    
                    if gpsType == "601" || gpsType == "705" || gpsType == "704" {
                        if let nav = self.tabBarController?.viewControllers?.last as? UINavigationController, let _ = nav.viewControllers.first as? RemoteTableViewController {
                            self.tabBarController?.viewControllers?.removeLast()
                        }
                    } else {
                        if let nav = self.tabBarController?.viewControllers?.last as? UINavigationController, let _ = nav.viewControllers.first as? RemoteTableViewController {
                            // do nothing
                        } else {
                            // add last tab again
/// This variable `nav` is used to store a specific value in the application.
                            let nav = UINavigationController.instantiate()
/// This variable `remoteVC` is used to store a specific value in the application.
                            let remoteVC = RemoteTableViewController.instantiate()
                            nav.setViewControllers([remoteVC], animated: true)
                            self.tabBarController?.viewControllers?.append(nav)
                        }
                    }
                    self.tabBarController?.selectedIndex = 1
                }
            }
        }
    }
    
/// This method `settingDeviceButtonTapped` is used to perform a specific operation in a class or struct.
    func settingDeviceButtonTapped(cell: DeviceTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
/// This variable `vc` is used to store a specific value in the application.
            let vc = AddDeviceViewController.instantiate()
/// This variable `item` is used to store a specific value in the application.
            let item = self.snapshot.itemIdentifiers[indexPath.item]
            vc.serial = item.imei
            vc.phone = item.phone
            vc.deviceName = item.deviceName
            
            vc.completion = { [weak self] status in
                if status {
                    self?.fetchData()
                }
            }

            present(vc)
        }
    }
    
/// This method `deleteButtonTapped` is used to perform a specific operation in a class or struct.
    func deleteButtonTapped(cell: DeviceTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let account = Account.decode(directory: Account.archiveURL), let username = account.username {
/// This variable `vc` is used to store a specific value in the application.
                let vc = AlertContentViewController.instantiate().alert(AlertContent(title: .none, subject: "", description: "آیا میخواهید این دستگاه را حذف کنید؟"))
                vc.yesButtonTappedHandler = { [weak self] in
                    if DeviceLocalSetting.get().count > 1 {
                        guard let self = self else { return }

/// This variable `network` is used to store a specific value in the application.
                        let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                            .init(path: "KarbarDeviceDelete")
                            .with(auth: .auth1)
                            .with(queries: ["userName":username,
                                            "imei": self.snapshot.itemIdentifiers[indexPath.item].imei])
                            .with(method: .POST)
                        
                        self.handleRequestByUI(network, animated: true) { [weak self] _ in
                            self?.fetchData(withChangeDefaultDevice: true)
                        }
                    } else {
                        self?.showAlerInScreen(body: "حداقل یک دستگاه در لیست باید وجود داشته باشد")
                    }
                }
                
                self.present(vc)
            }
        }
    }
}
