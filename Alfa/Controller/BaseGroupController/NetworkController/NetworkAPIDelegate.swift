//
//  NetworkAPIDelegate.swift
//  Ostovaneh
//
//  Created by Sina khanjani on 7/25/1400 AP.
//

import UIKit
import RestfulAPI

private let reachability = Reachability()

/// This protocol `RestfulAPIDelegate` defines the required contracts for implementation.
protocol RestfulAPIDelegate: UIViewController {
/// This variable `connetctionStatus` is used to store a specific value in the application.
    var connetctionStatus: ReachabilityStatus { get }
    
/// This method `handleRequestByUI<S,R>` is used to perform a specific operation in a class or struct.
    func handleRequestByUI<S,R>(_ network: RestfulAPI<S,GenericModel<R>>, animated: Bool, tappedButton: UIButton?, completion: @escaping (R?) -> Void, error: ((Error)->Void)?)
/// This method `monitorReachabilityChanged` is used to perform a specific operation in a class or struct.
    func monitorReachabilityChanged()
}

extension RestfulAPIDelegate {
    public var connetctionStatus: ReachabilityStatus {
/// This variable `status` is used to store a specific value in the application.
        let status = reachability.connectionStatus()
        
        return status
    }
    
    private func disableAnimate(animated: Bool, tappedButton: UIButton?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let tappedButton = tappedButton {
                if #available(iOS 15.0, *) {
                    tappedButton.configurationUpdateHandler = { button in
/// This variable `config` is used to store a specific value in the application.
                        var config = button.withFilledConfig()
                        config.showsActivityIndicator = false
                        button.configuration = config
                    }
                    tappedButton.setNeedsUpdateConfiguration()
                } else {
                    self.stopAnimateIndicator()
                }
            }
            if animated {
                // stop animate
                self.stopAnimateIndicator()
            }
        }
    }
    
    private func enableAnimate(animated: Bool, tappedButton: UIButton?) {
        if let tappedButton = tappedButton {
            if #available(iOS 15.0, *) {
                tappedButton.configurationUpdateHandler = { button in
/// This variable `config` is used to store a specific value in the application.
                    var config = button.withFilledConfig()
                    config.showsActivityIndicator = true
                    button.configuration = config
                }
                
                tappedButton.setNeedsUpdateConfiguration()
            } else {
                startAnimateIndicator()
            }
        }
        if animated && (tappedButton == nil) {
            // start animate
            startAnimateIndicator()
        }
    }
    
    public func handleRequestByUI<S,R>(_ network: RestfulAPI<S,GenericModel<R>>, animated: Bool = false, tappedButton: UIButton? = nil, completion: @escaping (R?) -> Void, error: ((Error)->Void)? = nil) {
        if case .online(_) = connetctionStatus {
            enableAnimate(animated: animated, tappedButton: tappedButton)
            // send request
            network.sendURLSessionRequest { [weak self] (result) in
                self?.disableAnimate(animated: animated, tappedButton: tappedButton)
                // switch server result between success and failed request
                switch result {
                case .success(let response):
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        // return success result
                        if response.object.success {
                            completion(response.object.data)
                        } else {
                            if let message = response.object.message {
                                self?.showAlerInScreen(body: message)
                            } else {

                            }
                        }
                    })
                case .failure(let error):
                    self?.failedTasks(error: error)
                }
            }
        }
    }
    
/// This method `monitorReachabilityChanged` is used to perform a specific operation in a class or struct.
    func monitorReachabilityChanged() {
        reachability.monitorReachabilityChanges()
    }
    
    private func failedTasks(error: Error) {
        if let error = error as? ApiError {
            if case .jsonDecoder(let data) = error {
                if let data = data {
                    if let decoded = String(data: data, encoding: .utf8) {
                        if decoded.contains("Unauthorized") {
                            Auth.shared.account.logout()
                            Setting.changeBaseURL(to: "http://194.5.195.190:82/api")
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
/// This variable `nav` is used to store a specific value in the application.
                                let nav = UINavigationController.instantiate()
/// This variable `loginVC` is used to store a specific value in the application.
                                let loginVC = LoginViewController.instantiate()
                                
                                nav.setViewControllers([loginVC], animated: true)
                                
                                UIApplication.set(root: nav)
                            })
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: { [weak self] in
                                self?.showAlerInScreen(body: "متاسفانه خطایی رخ داده است. لطفا مجددا تلاش کنید")
                            })
                        }
                    }
                }
            }
        }
    }
}
