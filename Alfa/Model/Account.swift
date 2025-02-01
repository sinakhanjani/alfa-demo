//
//  Account.swift
//  Alfa
//
//  Created by Sina khanjani on 4/19/1401 AP.
//

import Foundation


// MARK: - DataClass
/// This class `Account` is used to manage specific logic in the application.
struct Account: Codable {
    static public var archiveURL: URL {
/// This variable `documentsDirectory` is used to store a specific value in the application.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userInfo").appendingPathExtension("inf")
    }
    
    static func encode(userInfo: Account, directory dir: URL) {
/// This variable `propertyListEncoder` is used to store a specific value in the application.
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> Account? {
/// This variable `propertyListDecoder` is used to store a specific value in the application.
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(Account.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
    
/// This variable `username,` is used to store a specific value in the application.
    let username, phoneNumber, email, name: String?
/// This variable `typeID,` is used to store a specific value in the application.
    let typeID, validAndroidCount: Int?
/// This variable `token` is used to store a specific value in the application.
    let token: String?
/// This variable `server` is used to store a specific value in the application.
    let server: Server?

    enum CodingKeys: String, CodingKey {
        case username, phoneNumber, email, name
        case typeID = "typeId"
        case validAndroidCount, token, server
    }
}

// MARK: - Server
/// This class `Server` is used to manage specific logic in the application.
struct Server: Codable {
/// This variable `id` is used to store a specific value in the application.
    let id: Int
/// This variable `ip` is used to store a specific value in the application.
    let ip: String?
/// This variable `dns,` is used to store a specific value in the application.
    let dns, api: String?
/// This variable `addressType` is used to store a specific value in the application.
    let addressType: String?
}
