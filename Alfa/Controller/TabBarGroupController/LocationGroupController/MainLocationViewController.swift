//
//  MainLocationViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import UIKit
import RestfulAPI
import DropDown

/// This class `MainLocationViewController` is used to manage specific logic in the application.
class MainLocationViewController: BaseViewController {

    @IBOutlet weak var segmetnControl: UISegmentedControl!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var timeAgoView: UIView!
    
/// This variable `lastTabView` is used to store a specific value in the application.
    var lastTabView: UIView?
/// This variable `childVC` is used to store a specific value in the application.
    var childVC: UIViewController?
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var dropDown: DropDown!
        
/// This variable `refDropDown` is used to store a specific value in the application.
    var refDropDown: DropDown?
    
/// This variable `routeItems` is used to store a specific value in the application.
    var routeItems: [RouteItem]?
/// This variable `startDateFilter` is used to store a specific value in the application.
    var startDateFilter: Date?
/// This variable `endDateFilter` is used to store a specific value in the application.
    var endDateFilter: Date?
/// This variable `selectedIndex` is used to store a specific value in the application.
    var selectedIndex: Int?
    
/// This variable `selectedSegmentIndex` is used to store a specific value in the application.
    var selectedSegmentIndex: Int?
/// This variable `selectedRow` is used to store a specific value in the application.
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmetnControl.selectedSegmentIndex = 2

        refDropDown = dropDown

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.carButton.setTitle(item, for: .normal)
            
            if self.segmetnControl.selectedSegmentIndex == 2 {
                if index == 0 {
                    // do nothing
                } else {
                    DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[index-1]
/// This variable `gpsType` is used to store a specific value in the application.
                    let gpsType = DeviceLocalSetting.get()[index-1].car.gpsType
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
                }
            } else {
                DeviceLocalSetting.defaultItem = DeviceLocalSetting.get()[index]
                
/// This variable `gpsType` is used to store a specific value in the application.
                let gpsType = DeviceLocalSetting.get()[index].car.gpsType
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
            }
            
            NotificationCenter.default.post(name: .defaultDeviceChanged, object: nil)
        }

        dropDown.width = UIScreen.main.bounds.width-32
        dropDown.direction = .bottom
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceFetched), name: .deviceFetched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(defaultDeviceChanged), name: .defaultDeviceChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
/// This variable `all` is used to store a specific value in the application.
        var all = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        
        if segmetnControl.selectedSegmentIndex == 2 {
            if !all.contains("همه") {
                all.insert("همه", at: 0)
            }
        }
        
        if let selectedSegmentIndex = selectedSegmentIndex {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                self.carButton.setTitle(self.dropDown.selectedItem, for: .normal)
            }
            self.segmetnControl.selectedSegmentIndex = selectedSegmentIndex
        }

        dropDown.dataSource = all
        dropDown.reloadAllComponents()

        if let _ = selectedSegmentIndex, let selectedRow = selectedRow {
            self.dropDown.selectRow(at: selectedRow)
            self.selectedSegmentIndex = nil
        }
        
        if let defaultItem = DeviceLocalSetting.defaultItem {
            updateUIElement(defaultItem: defaultItem)
        }
        
        if let defaultDevice = DeviceLocalSetting.defaultItem {
            carButton.setTitle(defaultDevice.car.deviceName, for: .normal)
            if let lastDate = defaultDevice.car.lastZaman?.toDate() {
/// This variable `delta` is used to store a specific value in the application.
                let delta = lastDate - Date()
/// This variable `hourDelta` is used to store a specific value in the application.
                let hourDelta = (delta/60)/60
                if -hourDelta >= 2 {
                    self.timeAgoView.alpha = 1.0
                } else {
                    self.timeAgoView.alpha = 0
                }
            }
        }
    }

    @objc func deviceFetched() {
/// This variable `all` is used to store a specific value in the application.
        var all = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
        if segmetnControl.selectedSegmentIndex == 2 {
            all.insert("همه", at: 0)
        }
        dropDown.dataSource = all
        dropDown.reloadAllComponents()
    }
    
    @objc func defaultDeviceChanged() {
        if let defaultItem = DeviceLocalSetting.defaultItem {
            updateUIElement(defaultItem: defaultItem)
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        dropDown.show()
    }
        
    @IBAction func segmentControlValueChanhed(_ sender: UISegmentedControl) {
        setTabView(index: sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 2 {
/// This variable `all` is used to store a specific value in the application.
            var all = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
            all.insert("همه", at: 0)
            dropDown.dataSource = all
            dropDown.reloadAllComponents()
        } else {
            if let defaultDevice = DeviceLocalSetting.defaultItem {
                carButton.setTitle(defaultDevice.car.deviceName, for: .normal)
            }
            
/// This variable `all` is used to store a specific value in the application.
            let all = DeviceLocalSetting.get().map { $0.car.deviceName ?? "-"}
            dropDown.dataSource = all
            dropDown.reloadAllComponents()
        }
    }
    
/// This method `updateUIElement` is used to perform a specific operation in a class or struct.
    func updateUIElement(defaultItem: DeviceLocalSetting) {
        if let lastDate = defaultItem.car.lastZaman?.toDate() {
/// This variable `delta` is used to store a specific value in the application.
            let delta = lastDate - Date()
/// This variable `hourDelta` is used to store a specific value in the application.
            let hourDelta = (delta/60)/60
            if segmetnControl.selectedSegmentIndex == 2 {
                if self.dropDown.indexForSelectedRow == 0 {
                    self.timeAgoView.alpha = 0
                } else {
                    if -hourDelta >= 2 {
                        self.timeAgoView.alpha = 1.0
                    } else {
                        self.timeAgoView.alpha = 0
                    }
                }
            } else {
                if -hourDelta >= 2 {
                    self.timeAgoView.alpha = 1.0
                } else {
                    self.timeAgoView.alpha = 0
                }
            }
        }
        
        self.endDateFilter = nil
        self.startDateFilter = nil
        self.routeItems = nil
        
        setTabView(index: segmetnControl.selectedSegmentIndex)
    }
    
/// This method `setTabView` is used to perform a specific operation in a class or struct.
    func setTabView(index: Int) {
        lastTabView?.removeFromSuperview()
        lastTabView = nil
        childVC?.removeFromParent()
        childVC = nil

        switch index {
        case 0:
/// This variable `vc` is used to store a specific value in the application.
            let vc = RouteViewController.instantiate()
            vc.routeItems = routeItems
            vc.selectedIndex = selectedIndex
            vc.startDate = startDateFilter
            vc.endDate = endDateFilter
            if let defaultItem = DeviceLocalSetting.defaultItem {
                vc.deviceLocalSetting = defaultItem
            }
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tabView.frame.height)
            tabView.addSubview(vc.view)
            vc.didMove(toParent: self)
            lastTabView = vc.view
            childVC = vc
        case 1:
/// This variable `vc` is used to store a specific value in the application.
            let vc = RouteListViewController.instantiate()
            vc.delegate = self
            if let defaultItem = DeviceLocalSetting.defaultItem {
                vc.deviceLocalSetting = defaultItem
            }
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tabView.frame.height)
            tabView.addSubview(vc.view)
            vc.didMove(toParent: self)
            lastTabView = vc.view
            childVC = vc
        case 2:
/// This variable `vc` is used to store a specific value in the application.
            let vc = LastLocationViewController.instantiate()
            if self.dropDown.indexForSelectedRow == 0 {
                if self.dropDown.selectedItem != "همه" {
                    if let defaultItem = DeviceLocalSetting.defaultItem {
                        vc.deviceLocalSettings = [defaultItem]
                    }
                } else {
                    vc.deviceLocalSettings = DeviceLocalSetting.get()
                }
            } else {
                if let defaultItem = DeviceLocalSetting.defaultItem {
                    vc.deviceLocalSettings = [defaultItem]
                }
            }
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tabView.frame.height)
            tabView.addSubview(vc.view)
            vc.didMove(toParent: self)
            lastTabView = vc.view
            childVC = vc
        default:
            break
        }
    }
}

extension MainLocationViewController: RouteListViewControllerDelegate {
/// This method `filterDateValueChanged` is used to perform a specific operation in a class or struct.
    func filterDateValueChanged(startDate: Date, endDate: Date) {
        segmetnControl.selectedSegmentIndex = 0
        self.startDateFilter = startDate
        self.endDateFilter = endDate
        self.selectedIndex = nil
        self.setTabView(index: segmetnControl.selectedSegmentIndex)
    }
    
/// This method `didSelectedRouteAt` is used to perform a specific operation in a class or struct.
    func didSelectedRouteAt(index: Int, routeItems: [RouteItem]) {
        segmetnControl.selectedSegmentIndex = 0
        self.selectedIndex = index
        self.routeItems = routeItems
        self.startDateFilter = nil
        self.endDateFilter = nil
        self.setTabView(index: segmetnControl.selectedSegmentIndex)
    }
}
