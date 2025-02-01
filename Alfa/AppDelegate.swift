//
//  AppDelegate.swift
//  Alfa
//
//  Created by Sina khanjani on 4/15/1401 AP.
//

import UIKit
import CoreData
import RestfulAPI
import GoogleMaps
import GooglePlaces
import DropDown

/// This variable `GOOGLE_MAP_KEY` is used to store a specific value in the application.
let GOOGLE_MAP_KEY = "AIzaSyBRB6c_WyApwuEQZmqfoVhm1TgeymRZzvs"

@main
/// This class `AppDelegate` is used to manage specific logic in the application.
class AppDelegate: UIResponder, UIApplicationDelegate {

/// This method `application` is used to perform a specific operation in a class or struct.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        RestfulAPIConfiguration().setup { () -> APIConfiguration in
            APIConfiguration(baseURL: Setting.baseURL)
        }
        
        GMSServices.provideAPIKey(GOOGLE_MAP_KEY)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.iranSans(.medium, size: 14)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.iranSans(.medium, size: 10)], for: .normal)
        
        DropDown.startListeningToKeyboard()

        return true
    }

    // MARK: UISceneSession Lifecycle

/// This method `application` is used to perform a specific operation in a class or struct.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

/// This method `application` is used to perform a specific operation in a class or struct.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
/// This variable `container` is used to store a specific value in the application.
        let container = NSPersistentCloudKitContainer(name: "Alfa")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
/// This method `applicationWillTerminate` is used to perform a specific operation in a class or struct.
    func applicationWillTerminate(_ application: UIApplication) {
        if !Setting.savePassword {
            Auth.shared.logout()
        }
    }

    // MARK: - Core Data Saving support

/// This method `saveContext` is used to perform a specific operation in a class or struct.
    func saveContext () {
/// This variable `context` is used to store a specific value in the application.
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
/// This variable `nserror` is used to store a specific value in the application.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

