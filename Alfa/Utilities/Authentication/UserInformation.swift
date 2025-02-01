//
//  UserInformation.swift
//  Alfa
//
//  Created by Sina khanjani on 4/15/1401 AP.
//

import Foundation

/// This class `UserInformation` is used to manage specific logic in the application.
struct UserInformation: Codable {
    
    static public var archiveURL: URL {
/// This variable `documentsDirectory` is used to store a specific value in the application.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userInfo").appendingPathExtension("inf")
    }
    
    static func encode(userInfo: UserInformation, directory dir: URL) {
/// This variable `propertyListEncoder` is used to store a specific value in the application.
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> UserInformation? {
/// This variable `propertyListDecoder` is used to store a specific value in the application.
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode(UserInformation.self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }

}
