//
//  StarterViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/18/1401 AP.
//

import UIKit
import RestfulAPI

/// This class `StarterViewController` is used to manage specific logic in the application.
class StarterViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Setting.isFaceIDEnable {
            authenticateWithTouchID {[weak self] ok in
                OperationQueue.main.addOperation({
                    if ok {
                        self?.loginRoutes()
                    } else {
/// This variable `vc` is used to store a specific value in the application.
                        let vc = EnterPasswordViewController.instantiate()
                        vc.completion = { [weak self] states in
                            if states {
                                self?.loginRoutes()
                            }
                        }
                        self?.present(vc)
                    }
                })
            }
        } else {
            loginRoutes()
        }
    }
    
/// This method `loginRoutes` is used to perform a specific operation in a class or struct.
    func loginRoutes() {
        if Auth.shared.isLogin {
            if case .online(_) = connetctionStatus {
                if Setting.savePassword {
                    // TABBARCONTROLER
/// This variable `tab` is used to store a specific value in the application.
                    let tab = UITabBarController
                        .instantiate()
                    present(tab)
                } else {
/// This variable `nav` is used to store a specific value in the application.
                    let nav = UINavigationController
                        .instantiate()
/// This variable `loginVC` is used to store a specific value in the application.
                    let loginVC = LoginViewController
                        .instantiate()
                    
                    nav.setViewControllers([loginVC], animated: true)
                    
                    UIApplication.set(root: nav)
                }
            } else {
/// This variable `nav` is used to store a specific value in the application.
                let nav = UINavigationController
                    .instantiate()
/// This variable `loginVC` is used to store a specific value in the application.
                let loginVC = LoginViewController
                    .instantiate()
                
                nav.setViewControllers([loginVC], animated: true)
                
                UIApplication.set(root: nav)
            }
        } else {
            if Setting.chached {
/// This variable `nav` is used to store a specific value in the application.
                let nav = UINavigationController
                    .instantiate()
/// This variable `loginVC` is used to store a specific value in the application.
                let loginVC = LoginViewController
                    .instantiate()
                
                nav.setViewControllers([loginVC], animated: true)
                
                UIApplication.set(root: nav)
            } else {
/// This variable `nav` is used to store a specific value in the application.
                let nav = UINavigationController
                    .instantiate()
/// This variable `authVC` is used to store a specific value in the application.
                let authVC = AuthViewController
                    .instantiate()
                
                nav.setViewControllers([authVC], animated: true)
                
                UIApplication.set(root: nav)
            }
            
        }
    }
}
