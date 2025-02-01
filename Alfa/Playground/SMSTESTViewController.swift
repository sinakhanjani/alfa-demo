//
//  SMSTESTViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/18/1401 AP.
//

import UIKit
import MessageUI

/// This class `SMSTESTViewController` is used to manage specific logic in the application.
class SMSTESTViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if MFMessageComposeViewController.canSendText() {
/// This variable `composeVC` is used to store a specific value in the application.
            let composeVC = MFMessageComposeViewController()
            
            composeVC.messageComposeDelegate = self
            composeVC.recipients = ["09125933044"]
            composeVC.body = "ARM09125933044"
            
            present(composeVC, animated: true, completion: nil)
        }
    }
    
/// This method `messageComposeViewController` is used to perform a specific operation in a class or struct.
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
}
