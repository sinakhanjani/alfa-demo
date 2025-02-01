//
//  UIViewExtension.swift
//  Master
//
//  Created by Sina khanjani on 10/9/1399 AP.
//
import UIKit
import ProgressHUD
import LocalAuthentication

extension UIViewController {
    /// Instantiate ViewController by identifier on storyboard
    public static func instantiate(storyboard name: String = "Main") -> Self {
/// This method `create<T` is used to perform a specific operation in a class or struct.
        func create<T : UIViewController> (type: T.Type) -> T {
/// This variable `uiStoryboard` is used to store a specific value in the application.
            let uiStoryboard = UIStoryboard(name: name, bundle: nil)
/// This variable `vc` is used to store a specific value in the application.
            let vc: T = uiStoryboard.instantiateViewController(identifier:  String(describing: self)) { (coder) -> T? in
                T(coder: coder)
            }
            
            return vc
        }
        
        return create(type: self)
    }
    /// Instantiate View Controller by storyboard identifier ID
    public static func instantiate(storyboard name: String = "Main", withId id: String) -> UIViewController {
/// This variable `uiStoryboard` is used to store a specific value in the application.
        let uiStoryboard = UIStoryboard(name: name, bundle: nil)
/// This variable `vc` is used to store a specific value in the application.
        let vc = uiStoryboard.instantiateViewController(withIdentifier: id)
        
        return vc
    }
    /// Return current ViewController identifierID
    @objc class var identifier: String {
        return String(describing: self)
    }
    
    public func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

extension UIViewController {
/// This method `register` is used to perform a specific operation in a class or struct.
    func register(_ tableView: UITableView, with cell: UITableViewCell.Type) {
/// This variable `nib` is used to store a specific value in the application.
        let nib = UINib(nibName: cell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell.identifier)
    }
    
/// This method `register` is used to perform a specific operation in a class or struct.
    func register(_ collectionView: UICollectionView, with cell: UICollectionViewCell.Type) {
/// This variable `nib` is used to store a specific value in the application.
        let nib = UINib(nibName: cell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cell.identifier)
    }
}

extension UIViewController {
/// This method `startAnimateIndicator` is used to perform a specific operation in a class or struct.
    func startAnimateIndicator() {
        ProgressHUD.show()
    }
    
/// This method `stopAnimateIndicator` is used to perform a specific operation in a class or struct.
    func stopAnimateIndicator() {
        ProgressHUD.dismiss()
    }
}

extension UIViewController {
/// This method `showAlerInScreen` is used to perform a specific operation in a class or struct.
    func showAlerInScreen(title: String = "", body: String) {
/// This variable `alertContent` is used to store a specific value in the application.
        let alertContent = AlertContent(title: .none, subject: title, description: body)
        present(WarningContentViewController
                    .instantiate()
                    .alert(alertContent))
    }
}

extension UIViewController {
/// This method `authenticateWithTouchID` is used to perform a specific operation in a class or struct.
    func authenticateWithTouchID(_ escape: @escaping (_ state: Bool) -> Void) {
/// This variable `localAuthContext` is used to store a specific value in the application.
        let localAuthContext = LAContext()
/// This variable `faText` is used to store a specific value in the application.
        let faText = "لطفا رمز عبور را وارد کنید"
/// This variable `authError` is used to store a specific value in the application.
        var authError: NSError?
        if !localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authError) {
            if let error = authError {
                print(error.localizedDescription)
            }
            // Display the login dialog when Touch ID is not available (e.g. in simulator)
            return
        }
        localAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: faText, reply: { (success: Bool, error: Error?) -> Void in
            if !success {
                escape(false)
            } else {
                escape(true)
            }
        })
    }
}
