//
//  File.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import Foundation

// MARK: - Car
/// This class `Car` is used to manage specific logic in the application.
struct Car: Decodable, Encodable, Hashable {
/// This variable `imei` is used to store a specific value in the application.
    let imei: String
/// This variable `gpsType,` is used to store a specific value in the application.
    let gpsType, phone, devicePass: String
/// This variable `userName` is used to store a specific value in the application.
    let userName: String?
/// This variable `validDeviceCount` is used to store a specific value in the application.
    let validDeviceCount: Int?
/// This variable `active` is used to store a specific value in the application.
    let active: Bool?
/// This variable `name,` is used to store a specific value in the application.
    let name, deviceName: String?
/// This variable `defaultDeviceID` is used to store a specific value in the application.
    let defaultDeviceID: Int?
/// This variable `accessID` is used to store a specific value in the application.
    let accessID: Int?
/// This variable `lastLatitude,` is used to store a specific value in the application.
    let lastLatitude, lastLongitude, lastZaman, lastSpeed: String?
    
    
/// This variable `lastAcc` is used to store a specific value in the application.
    let lastAcc: Bool?
/// This variable `validTrip,` is used to store a specific value in the application.
    let validTrip, lastAngle: Int?
/// This variable `password2,` is used to store a specific value in the application.
    let password2, expireDate: String?
/// This variable `remainDays` is used to store a specific value in the application.
    let remainDays: Int?
/// This variable `currentDate` is used to store a specific value in the application.
    let currentDate: String?
/// This variable `validAndroidCount` is used to store a specific value in the application.
    let validAndroidCount: Int?

    enum CodingKeys: String, CodingKey {
        case imei, gpsType, phone, devicePass, userName, validDeviceCount, active, name, deviceName
        case defaultDeviceID = "defaultDeviceId"
        case accessID = "accessId"
        case lastLatitude, lastLongitude, lastZaman, lastSpeed, lastAcc, validTrip, lastAngle, password2, expireDate, remainDays, currentDate, validAndroidCount
    }
}
