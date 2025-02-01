//
//  WebViewViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/18/1401 AP.
//

import UIKit
import WebKit

/// This class `WebViewViewController` is used to manage specific logic in the application.
class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
/// This variable `url` is used to store a specific value in the application.
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url  = url {
/// This variable `req` is used to store a specific value in the application.
            let req = URLRequest(url: url)
            webView.load(req)
        }
    }
}
