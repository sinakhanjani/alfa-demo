//
//  DeviceLocalSetting.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import Foundation

/// This class `DeviceLocalSetting` is used to manage specific logic in the application.
struct DeviceLocalSetting: Codable {
    static public var archiveURL: URL {
/// This variable `documentsDirectory` is used to store a specific value in the application.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("devLocalSetting").appendingPathExtension("inf")
    }
    
    static func encode(userInfo: [DeviceLocalSetting], directory dir: URL) {
/// This variable `propertyListEncoder` is used to store a specific value in the application.
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(userInfo) {
            try! encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> [DeviceLocalSetting] {
/// This variable `propertyListDecoder` is used to store a specific value in the application.
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode([DeviceLocalSetting].self, from: retrievedProductData) {
            return decodedProduct
        }
        return []
    }
    
    // objects
/// This variable `isSwitchOn` is used to store a specific value in the application.
    var isSwitchOn: Bool = false
/// This variable `sendSMS` is used to store a specific value in the application.
    var sendSMS: Bool = true

/// This variable `shenod` is used to store a specific value in the application.
    var shenod: Bool = false
/// This variable `sens` is used to store a specific value in the application.
    var sens: Int = 0
/// This variable `km` is used to store a specific value in the application.
    var km: String = ""

/// This variable `car` is used to store a specific value in the application.
    var car: Car
    
    // props
    static var defaultItem: DeviceLocalSetting? {
        get {
            if DeviceLocalSetting.items.isEmpty {
                return nil
            } else {
/// This variable `_defaultIndex` is used to store a specific value in the application.
                let _defaultIndex = UserDefaults.standard.integer(forKey: "defaultItem_x")
                return DeviceLocalSetting.items[_defaultIndex]
            }
        }
        set {
/// This variable `index` is used to store a specific value in the application.
            let index = DeviceLocalSetting.items.firstIndex { item in
                item.car.imei == newValue?.car.imei
            }
            UserDefaults.standard.set(index, forKey: "defaultItem_x")
        }
    }
    
    // CRUD
    static private var items: [DeviceLocalSetting] {
        DeviceLocalSetting.decode(directory: DeviceLocalSetting.archiveURL)
    }
    
    static func get() -> [DeviceLocalSetting] {
        items
    }
    
    static func update(item: DeviceLocalSetting) {
        if let index = items.firstIndex(where: { $0.car.imei == item.car.imei }) {
/// This variable `data` is used to store a specific value in the application.
            var data = DeviceLocalSetting.items
            data[index] = item
            
            DeviceLocalSetting.encode(userInfo: data, directory: DeviceLocalSetting.archiveURL)
        }
    }
    
    static func insert(cars: [Car]) {
/// This variable `all` is used to store a specific value in the application.
        var all = [DeviceLocalSetting]()
        
        cars.forEach { car in
            if let index = DeviceLocalSetting.items.firstIndex(where: { i in
                i.car.imei == car.imei
            }) {
/// This variable `x` is used to store a specific value in the application.
                var x = DeviceLocalSetting.items[index]
                x.car = car
                all.append(x)
            } else {
                all.append(DeviceLocalSetting(car: car))
            }
        }
        
        DeviceLocalSetting.encode(userInfo: all, directory: DeviceLocalSetting.archiveURL)
    }
}
