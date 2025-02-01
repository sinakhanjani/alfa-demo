//
//  RouteItem.swift
//  Alfa
//
//  Created by Sina khanjani on 4/23/1401 AP.
//

import Foundation

// MARK: - RouteItem
/// This class `RouteItem` is used to manage specific logic in the application.
struct RouteItem: Codable, Hashable {
/// This variable `id` is used to store a specific value in the application.
    let id: Int?
/// This variable `imei` is used to store a specific value in the application.
    let imei: String?
/// This variable `startID,` is used to store a specific value in the application.
    let startID, lastPID, lastZid, pNumber: Int?
/// This variable `zNumber` is used to store a specific value in the application.
    let zNumber: Int?
/// This variable `startOk,` is used to store a specific value in the application.
    let startOk, endOk: Bool?
/// This variable `startLat,` is used to store a specific value in the application.
    let startLat, startLong: Double?
/// This variable `startZaman,` is used to store a specific value in the application.
    let startZaman, lastZaman: String?
/// This variable `pointNumbers,` is used to store a specific value in the application.
    let pointNumbers, fixTime, duration, masafat: Int?
/// This variable `masafatMiangin` is used to store a specific value in the application.
    let masafatMiangin: Int?
/// This variable `forTest` is used to store a specific value in the application.
    let forTest: Bool?

    enum CodingKeys: String, CodingKey {
        case id, imei
        case startID = "startId"
        case lastPID = "lastPid"
        case lastZid, pNumber, zNumber, startOk, endOk, startLat, startLong, startZaman, lastZaman, pointNumbers, fixTime, duration, masafat, masafatMiangin, forTest
    }
}
