//
//  NetworkViewController.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 7/25/1400 AP.
//

import UIKit

/// This class `NetworkViewController` is used to manage specific logic in the application.
class NetworkViewController: UIViewController, RestfulAPIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorReachabilityChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanges(_:)), name: .reachabilityStatusChangedNotification, object: nil)
    }
    
    @objc func reachabilityStatusChanges(_ notification: Notification) {
        if let status = notification.userInfo?["Status"] as? ReachabilityStatus {
            switch status {
            case .offline:
                break
            case .online(_):
                break
            default:
                break
            }
        }
    }
}

/// This class `NetworkTableViewController` is used to manage specific logic in the application.
class NetworkTableViewController: UITableViewController, RestfulAPIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorReachabilityChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanges(_:)), name: .reachabilityStatusChangedNotification, object: nil)
    }
    
    @objc func reachabilityStatusChanges(_ notification: Notification) {
        if let status = notification.userInfo?["Status"] as? ReachabilityStatus {
            switch status {
            case .offline:
                break
            case .online(_):
                break
            default:
                break
            }
        }
    }
}

/// This class `NetworkCollecitonViewController` is used to manage specific logic in the application.
class NetworkCollecitonViewController: UICollectionViewController, RestfulAPIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorReachabilityChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanges(_:)), name: .reachabilityStatusChangedNotification, object: nil)
    }
    
    @objc func reachabilityStatusChanges(_ notification: Notification) {
        if let status = notification.userInfo?["Status"] as? ReachabilityStatus {
            switch status {
            case .offline:
                break
            case .online(_):
                break
            default:
                break
            }
        }
    }
}
