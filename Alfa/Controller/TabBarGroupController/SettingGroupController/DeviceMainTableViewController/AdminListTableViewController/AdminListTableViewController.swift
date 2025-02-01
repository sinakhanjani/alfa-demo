//
//  AdminListTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit
import RestfulAPI
import MessageUI

/// This class `AdminListTableViewController` is used to manage specific logic in the application.
class AdminListTableViewController: BaseTableViewController {
    
    enum Section: Hashable {
        case main
    }
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Admin>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Admin>()
    
/// This variable `selectedIndex` is used to store a specific value in the application.
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ادمین‌ها"
        
        tableViewDataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
/// This variable `cell` is used to store a specific value in the application.
            let cell = tableView.dequeueReusableCell(withIdentifier: AdminTableViewCell.identifier, for: indexPath) as! AdminTableViewCell
            
            cell.delegate = self
            cell.phoneLabel.text = itemIdentifier.admin
            
            return cell
        })
        
        fetch()
    }
    
    private func createSnapshot(items: [Admin]) -> NSDiffableDataSourceSnapshot<Section, Admin> {
/// This variable `snapshot` is used to store a specific value in the application.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Admin>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
    
/// This method `fetch` is used to perform a specific operation in a class or struct.
    func fetch() {
        if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `network` is used to store a specific value in the application.
            let network = RestfulAPI<EMPTYMODEL,GenericModel<[Admin]>>
                .init(path: "DeviceAdmin_Get")
                .with(auth: .auth1)
                .with(queries: ["imei":defaultDevice.car.imei])
            
            self.handleRequestByUI(network) { items in
                if let items = items {
                    // Reload snapshot
                    self.snapshot = self.createSnapshot(items: items)
                    self.tableViewDataSource.apply(self.snapshot)
                }
            }
        }

    }

    @IBAction func addAdminButtonTapped(_ sender: Any) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = AddAdminViewController.instantiate()
        vc.completion = { [weak self] phone in
            guard let self = self else { return }
            if let phone = phone {
                if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `network` is used to store a specific value in the application.
                    let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                        .init(path: "DeviceAdmin_Add")
                        .with(auth: .auth1)
                        .with(queries: ["imei":defaultDevice.car.imei,
                                        "admin":phone])
                    
                    self.handleRequestByUI(network) { [weak self] _ in
                        self?.fetch()
                    }
                }
            }
        }
        
        self.present(vc)
    }
}

extension AdminListTableViewController: AdminTableViewCellDelegate {
/// This method `deleteButtonTapped` is used to perform a specific operation in a class or struct.
    func deleteButtonTapped(cell: AdminTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
/// This variable `vc` is used to store a specific value in the application.
            let vc = AlertContentViewController.instantiate().alert(AlertContent(title: .none, subject: "", description: "آیا میخواهید این ادمین را حذف کنید؟"))
/// This variable `phone` is used to store a specific value in the application.
            let phone = self.snapshot.itemIdentifiers[indexPath.item].admin
            vc.yesButtonTappedHandler = { [weak self] in
                guard let self = self else { return }

                if let defaultDevice = DeviceLocalSetting.defaultItem {
/// This variable `pass` is used to store a specific value in the application.
                    let pass = defaultDevice.car.devicePass
                    if let phone = self.snapshot.itemIdentifiers[indexPath.item].admin {
                        self.sendMessage(body: "noadmin\(pass) \(phone)", phone: phone)
                        self.selectedIndex = indexPath.item
                    }
                }
            }
            
            self.present(vc)
        }
    }
}

// MARK: - Datum
/// This class `Admin` is used to manage specific logic in the application.
struct Admin: Codable, Hashable {
/// This variable `imei,` is used to store a specific value in the application.
    let imei, admin: String?
}

extension AdminListTableViewController: MFMessageComposeViewControllerDelegate {
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if let controller = controller as? CustomMFMessageComposeViewControllerDelegate {
            switch result {
            case .cancelled:
                break
            case .sent:
                if let selectedIndex = self.selectedIndex {
/// This variable `network` is used to store a specific value in the application.
                    let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                        .init(path: "DeviceAdmin_Delete")
                        .with(auth: .auth1)
                        .with(queries: ["admin":self.snapshot.itemIdentifiers[selectedIndex].admin!,
                                        "imei": self.snapshot.itemIdentifiers[selectedIndex].imei!])
                        .with(method: .GET)
                    
                    self.handleRequestByUI(network, animated: true) { [weak self] _ in
                        self?.fetch()
                    }
                }
            case .failed:
                break
            @unknown default:
                fatalError()
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
