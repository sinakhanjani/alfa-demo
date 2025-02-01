//
//  AlertContentViewController.swift
//  TEST
//
//  Created by Sina khanjani on 12/9/1399 AP.
//

import SwiftUI
import UIKit

final class AlertContentViewController: UIHostingController<AlertContentView> {
        
    public var yesButtonTappedHandler: (() ->Void)?
    public var noButtonTappedHandler: (() ->Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AlertContentView())
        rootView.yesButton = yesButtonTapped
        rootView.noButton = noButtonTapped

        view.backgroundColor = .clear
    }
    
    /// Add your custom alert message type as 'AlertContent'.
    public func alert(_ alertContent: AlertContent) -> Self {
        rootView.alertContentModelData = AlertContentModelData(alertContent: alertContent)
        
        return self
    }
    
    public func buttonTitle(yesTitle: String, noTitle: String) -> Self {
        rootView.yesTitle = yesTitle
        rootView.noTitle = noTitle
        
        return self
    }

    private func dismiss() {
        dismiss(animated: true)
    }
    
    private func yesButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.yesButtonTappedHandler?()
        }
    }
    
    private func noButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.noButtonTappedHandler?()
        }
    }
}
