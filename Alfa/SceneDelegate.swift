//
//  SceneDelegate.swift
//  Alfa
//
//  Created by Sina khanjani on 4/15/1401 AP.
//

import UIKit

/// This class `SceneDelegate` is used to manage specific logic in the application.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

/// This variable `window` is used to store a specific value in the application.
    var window: UIWindow?


/// This method `scene` is used to perform a specific operation in a class or struct.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

/// This method `sceneDidDisconnect` is used to perform a specific operation in a class or struct.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        if !Setting.savePassword {
            Auth.shared.logout()
        }
    }

/// This method `sceneDidBecomeActive` is used to perform a specific operation in a class or struct.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

/// This method `sceneWillResignActive` is used to perform a specific operation in a class or struct.
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

/// This method `sceneWillEnterForeground` is used to perform a specific operation in a class or struct.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

/// This method `sceneDidEnterBackground` is used to perform a specific operation in a class or struct.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

