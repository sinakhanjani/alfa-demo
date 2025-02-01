//
//  GenericModel.swift
//  Alfa
//
//  Created by Sina khanjani on 4/15/1401 AP.
//

import Foundation

/// This class `GenericModel<T` is used to manage specific logic in the application.
struct GenericModel<T: Codable>: Codable {
/// This variable `data` is used to store a specific value in the application.
    let data: T?
/// This variable `message` is used to store a specific value in the application.
    let message: String?
/// This variable `success` is used to store a specific value in the application.
    let success: Bool
}
