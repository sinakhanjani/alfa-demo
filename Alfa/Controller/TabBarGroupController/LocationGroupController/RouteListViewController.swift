//
//  RouteListViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import UIKit
import RestfulAPI

/// This protocol `RouteListViewControllerDelegate` defines the required contracts for implementation.
protocol RouteListViewControllerDelegate: AnyObject {
/// This method `filterDateValueChanged` is used to perform a specific operation in a class or struct.
    func filterDateValueChanged(startDate: Date, endDate: Date)
/// This method `didSelectedRouteAt` is used to perform a specific operation in a class or struct.
    func didSelectedRouteAt(index: Int, routeItems: [RouteItem])
}

/// This class `RouteListViewController` is used to manage specific logic in the application.
class RouteListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    enum Section: Hashable {
        case main
    }
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, RouteItem>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, RouteItem>()
    
    weak var delegate: RouteListViewControllerDelegate?
    
/// This variable `deviceLocalSetting` is used to store a specific value in the application.
    var deviceLocalSetting: DeviceLocalSetting?
/// This variable `routeItems` is used to store a specific value in the application.
    var routeItems: [RouteItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableViewDataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
/// This variable `cell` is used to store a specific value in the application.
            let cell = tableView.dequeueReusableCell(withIdentifier: RouteTableViewCell.identifier, for: indexPath) as! RouteTableViewCell
            cell.updateUI(item: itemIdentifier)
            
            return cell
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let deviceLocalSetting = deviceLocalSetting {
            fetchData(item: deviceLocalSetting)
        }
    }
    
    
    private func createSnapshot(items: [RouteItem]) -> NSDiffableDataSourceSnapshot<Section,RouteItem> {
/// This variable `snapshot` is used to store a specific value in the application.
        var snapshot = NSDiffableDataSourceSnapshot<Section,RouteItem>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)

        return snapshot
    }
    
/// This method `fetchData` is used to perform a specific operation in a class or struct.
    func fetchData(item: DeviceLocalSetting) {
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<[RouteItem]>>
            .init(path: "GetRouteByImei")
            .with(auth: .auth1)
            .with(queries: ["imei":item.car.imei,
                            "count":"10000"])
        self.handleRequestByUI(network) {[weak self] items in
            guard let self = self else { return }
            if let items = items {
                self.routeItems = items
                // Reload snapshot
                self.snapshot = self.createSnapshot(items: items)
                self.tableViewDataSource.apply(self.snapshot)
            }
        }
    }
    
    @IBAction func filterButtonTapped() {
/// This variable `vc` is used to store a specific value in the application.
        let vc = TimeFilterViewController.instantiate()
        vc.completion = { [weak self] (startDate, endDate) in
            self?.delegate?.filterDateValueChanged(startDate: startDate, endDate: endDate)
        }
        
        self.present(vc)
    }
}

extension RouteListViewController: UITableViewDelegate {
/// This method `tableView` is used to perform a specific operation in a class or struct.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let routeItems = routeItems {
            delegate?.didSelectedRouteAt(index: indexPath.item, routeItems: routeItems)
        }
    }
}
