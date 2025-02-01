//
//  NotificationNameExtention.swift
//  Master
//
//  Created by Sina khanjani on 11/26/1399 AP.
//

import Foundation

extension Notification.Name {
    static let reachabilityStatusChangedNotification =  NSNotification.Name(rawValue: "ReachabilityStatusChangedNotification")
    static let deviceFetched =  NSNotification.Name(rawValue: "devicedFetched")
    static let defaultDeviceChanged =  NSNotification.Name(rawValue: "defaultDeviceChanged")

}
