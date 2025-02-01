//
//  NotifTableViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/28/1401 AP.
//

import UIKit
import RestfulAPI

/// This class `NotifTableViewController` is used to manage specific logic in the application.
class NotifTableViewController: BaseTableViewController {

    
    enum Section: Hashable {
        case main
    }
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Elan>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Elan>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "اعلان‌ها"
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableViewDataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
/// This variable `cell` is used to store a specific value in the application.
            let cell = tableView.dequeueReusableCell(withIdentifier: NotifTableViewCell.identifier, for: indexPath) as! NotifTableViewCell
            
            cell.titleLabel.text = itemIdentifier.title
            cell.descriptionLabel.text = itemIdentifier.datumDescription
            return cell
        })
        
        fetch()
    }

    private func createSnapshot(items: [Elan]) -> NSDiffableDataSourceSnapshot<Section, Elan> {
/// This variable `snapshot` is used to store a specific value in the application.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Elan>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
    
/// This method `fetch` is used to perform a specific operation in a class or struct.
    func fetch() {
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<[Elan]>>
            .init(path: "Payam_Get")
            .with(auth: .auth1)
        
        self.handleRequestByUI(network) { items in
            if let items = items {
                // Reload snapshot
                self.snapshot = self.createSnapshot(items: items)
                self.tableViewDataSource.apply(self.snapshot)
            }
        }
    }
}

extension NotifTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Datum
/// This class `Elan` is used to manage specific logic in the application.
struct Elan: Codable, Hashable {
/// This variable `id` is used to store a specific value in the application.
    let id: Int
/// This variable `title,` is used to store a specific value in the application.
    let title, datumDescription: String?
/// This variable `active` is used to store a specific value in the application.
    let active: Bool?
/// This variable `expireDate` is used to store a specific value in the application.
    let expireDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case datumDescription = "description"
        case active, expireDate
    }
}
