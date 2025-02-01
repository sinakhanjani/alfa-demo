//
//  Reachability.swift
//
//  Created by Sina khanjani on 4/1/1400 AP.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

public enum ReachabilityType: CustomStringConvertible {
    case WWAN
    case WiFi
    
    public var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}

public enum ReachabilityStatus: CustomStringConvertible {
    case offline
    case online(ReachabilityType)
    case unknown
    
    public var description: String {
        switch self {
        case .offline: return "Offline".localized()
        case .online(let type): return "Online".localized() + "  (\(type))"
        case .unknown: return "Unknown".localized()
        }
    }
}

public class Reachability {
/// This method `connectionStatus` is used to perform a specific operation in a class or struct.
    func connectionStatus() -> ReachabilityStatus {
/// This variable `zeroAddress` is used to store a specific value in the application.
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = (withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return .unknown
        }
        
/// This variable `flags` is used to store a specific value in the application.
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
/// This method `monitorReachabilityChanges` is used to perform a specific operation in a class or struct.
    func monitorReachabilityChanges() {
/// This variable `host` is used to store a specific value in the application.
        let host = "google.com"
/// This variable `context` is used to store a specific value in the application.
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
/// This variable `reachability` is used to store a specific value in the application.
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
/// This variable `status` is used to store a specific value in the application.
            let status = ReachabilityStatus(reachabilityFlags: flags)
            
            NotificationCenter.default.post(name: .reachabilityStatusChangedNotification, object: nil, userInfo: ["Status": status])
        }, &context)
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
}

extension ReachabilityStatus {
    public init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
/// This variable `connectionRequired` is used to store a specific value in the application.
        let connectionRequired = flags.contains(.connectionRequired)
/// This variable `isReachable` is used to store a specific value in the application.
        let isReachable = flags.contains(.reachable)
/// This variable `isWWAN` is used to store a specific value in the application.
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            switch isWWAN {
            case true: self = .online(.WWAN)
            case false: self = .online(.WiFi)
            }
        } else {
            self = .offline
        }
    }
}
