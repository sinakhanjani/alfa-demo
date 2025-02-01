//
//  IMEIPoints.swift
//  Alfa
//
//  Created by Sina khanjani on 4/17/1401 AP.
//

import Foundation

// MARK: - Datum
/// This class `IMEIPoint` is used to manage specific logic in the application.
struct IMEIPoint: Codable {
/// This variable `id` is used to store a specific value in the application.
    let id: Int?
/// This variable `imei,` is used to store a specific value in the application.
    let imei, zaman, latitude, longitude: String?
/// This variable `speed` is used to store a specific value in the application.
    let speed: String?
/// This variable `acc,` is used to store a specific value in the application.
    let acc, lbs: Bool?
/// This variable `message` is used to store a specific value in the application.
    let message: String?
/// This variable `angle` is used to store a specific value in the application.
    let angle: Int?
/// This variable `zamanInt` is used to store a specific value in the application.
    let zamanInt: String?
}

