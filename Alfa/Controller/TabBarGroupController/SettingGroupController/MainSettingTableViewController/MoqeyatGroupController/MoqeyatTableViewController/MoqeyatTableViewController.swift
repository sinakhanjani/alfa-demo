//
//  MoqeyatTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 7/19/22.
//

import UIKit
import RestfulAPI

/// This class `MoqeyatTableViewController` is used to manage specific logic in the application.
class MoqeyatTableViewController: BaseTableViewController {
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!

    enum Section: Hashable {
        case main
    }
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Eshterak>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Eshterak>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.iranSans(.bold, size: 16)], for: .normal)
        rightBarItem.tintColor = .AlfaBlue

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        tableViewDataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
/// This variable `cell` is used to store a specific value in the application.
            let cell = tableView.dequeueReusableCell(withIdentifier: MoqeyatTableViewCell.identifier, for: indexPath) as! MoqeyatTableViewCell
            cell.delegate = self
            cell.update(item: itemIdentifier)
            
            return cell
        })
        
        fetch()
    }

    private func createSnapshot(items: [Eshterak]) -> NSDiffableDataSourceSnapshot<Section, Eshterak> {
/// This variable `snapshot` is used to store a specific value in the application.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Eshterak>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
    
/// This method `fetch` is used to perform a specific operation in a class or struct.
    func fetch() {
        if let account = Account.decode(directory: Account.archiveURL), let username = account.username {
/// This variable `network` is used to store a specific value in the application.
            let network = RestfulAPI<EMPTYMODEL,GenericModel<[Eshterak]>>
                .init(path: "Link_Get")
                .with(auth: .auth1)
                .with(queries: ["username":username])
            
            self.handleRequestByUI(network) { items in
                if let items = items {
                    // Reload snapshot
                    self.snapshot = self.createSnapshot(items: items)
                    self.tableViewDataSource.apply(self.snapshot)
                }
            }
        }
    }
    
    @IBAction func addLinkButtonTapped(_ sender: Any) {
/// This variable `vc` is used to store a specific value in the application.
        let vc = AddLinkViewController.instantiate()
        vc.completion = { [weak self] status in
            self?.fetch()
        }
        
        self.present(vc)
    }
}

extension MoqeyatTableViewController: MoqeyatTableViewCellDelegate {
/// This method `deleteMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func deleteMoqeyatTapped(cell: MoqeyatTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
/// This variable `item` is used to store a specific value in the application.
            let item = self.snapshot.itemIdentifiers[indexPath.item]
/// This variable `vc` is used to store a specific value in the application.
            let vc = AlertContentViewController.instantiate().alert(AlertContent(title: .none, subject: "", description: "آیا میخواهید این لینک را حذف کنید؟"))
            vc.yesButtonTappedHandler = { [weak self] in
                guard let self = self else { return }

/// This variable `network` is used to store a specific value in the application.
                let network = RestfulAPI<EMPTYMODEL,GenericModel<EMPTYMODEL>>
                    .init(path: "Link_delete")
                    .with(auth: .auth1)
                    .with(queries: ["id":"\(item.id)"])
                
                self.handleRequestByUI(network, animated: true) { [weak self] _ in
                    self?.fetch()
                }
            }
            
            self.present(vc)
        }
    }
    
/// This method `editMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func editMoqeyatTapped(cell: MoqeyatTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
/// This variable `item` is used to store a specific value in the application.
            let item = self.snapshot.itemIdentifiers[indexPath.item]
/// This variable `vc` is used to store a specific value in the application.
            let vc = AddLinkViewController.instantiate()
            vc.eshterak = item
            vc.completion = { [weak self] status in
                self?.fetch()
            }
            self.present(vc)
        }
    }
    
/// This method `shareMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func shareMoqeyatTapped(cell: MoqeyatTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
/// This variable `item` is used to store a specific value in the application.
            let item = self.snapshot.itemIdentifiers[indexPath.item]
/// This variable `text` is used to store a specific value in the application.
            let text = item.urlLink ?? ""
/// This variable `textShare` is used to store a specific value in the application.
             let textShare = [ text ]
/// This variable `activityViewController` is used to store a specific value in the application.
             let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            
             activityViewController.popoverPresentationController?.sourceView = self.view
            
             self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
/// This method `linkMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func linkMoqeyatTapped(cell: MoqeyatTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
/// This variable `item` is used to store a specific value in the application.
            let item = self.snapshot.itemIdentifiers[indexPath.item]
            URL.open(urlString: item.urlLink ?? "")
        }
    }
}


// MARK: - Datum
/// This class `Eshterak` is used to manage specific logic in the application.
struct Eshterak: Codable, Hashable {
/// This variable `id` is used to store a specific value in the application.
    let id: Int
/// This variable `userName,` is used to store a specific value in the application.
    let userName, imei: String?
/// This variable `active` is used to store a specific value in the application.
    let active: Bool?
/// This variable `expireDate` is used to store a specific value in the application.
    let expireDate: String?
/// This variable `urlLink` is used to store a specific value in the application.
    let urlLink: String?
}
