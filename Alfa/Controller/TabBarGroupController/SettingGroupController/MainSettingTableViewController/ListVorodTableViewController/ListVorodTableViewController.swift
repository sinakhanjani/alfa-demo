//
//  ListVorodTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/28/1401 AP.
//

import UIKit
import RestfulAPI

/// This class `ListVorodTableViewController` is used to manage specific logic in the application.
class ListVorodTableViewController: BaseTableViewController {
    
    enum Section: Hashable {
        case main
    }
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, ListVorod>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, ListVorod>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "لیست ورود"
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableViewDataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
/// This variable `cell` is used to store a specific value in the application.
            let cell = tableView.dequeueReusableCell(withIdentifier: ListVorodTableViewCell.identifier, for: indexPath) as! ListVorodTableViewCell
            if let model = itemIdentifier.model {
                cell.modelLabel.text = "مدل دستگاه: \(model)"
            }
            
            if let v = itemIdentifier.appVersion {
                cell.versionLabel.text = "نسخه نصب شده:‌ \(v)"
            }
            
            if let date = itemIdentifier.lastLogin {
                cell.lastEnterLabel.text = "آخرین ورود: \(date.to1(date: "yyyy-MM-dd HH:mm") ?? "")"
            }
            
            return cell
        })
        
        fetch()
    }

    private func createSnapshot(items: [ListVorod]) -> NSDiffableDataSourceSnapshot<Section, ListVorod> {
/// This variable `snapshot` is used to store a specific value in the application.
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListVorod>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
    
/// This method `fetch` is used to perform a specific operation in a class or struct.
    func fetch() {
        if let account = Account.decode(directory: Account.archiveURL), let username = account.username {
/// This variable `network` is used to store a specific value in the application.
            let network = RestfulAPI<EMPTYMODEL,GenericModel<[ListVorod]>>
                .init(path: "UserAndroid_Get")
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
}


// MARK: - Datum
/// This class `ListVorod` is used to manage specific logic in the application.
struct ListVorod: Codable, Hashable {
/// This variable `username,` is used to store a specific value in the application.
    let username, androidID, model, lastLogin: String?
/// This variable `appVersion` is used to store a specific value in the application.
    let appVersion: Int?

    enum CodingKeys: String, CodingKey {
        case username
        case androidID = "androidId"
        case model, lastLogin, appVersion
    }
}
