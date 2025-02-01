//
//  UIButtonExtension.swift
//  JobLoyal
//
//  Created by Sina khanjani on 3/2/1400 AP.
//

import UIKit

extension UIButton {
    @available(iOS 15.0, *)
/// This method `withFilledConfig` is used to perform a specific operation in a class or struct.
    func withFilledConfig() -> UIButton.Configuration {
/// This variable `filled` is used to store a specific value in the application.
        var filled = UIButton.Configuration.filled()
/// This variable `container` is used to store a specific value in the application.
        var container = AttributeContainer()
        
        container.font = UIFont.iranSans(.medium, size: titleLabel!.font.pointSize)
        filled.buttonSize = .large
        filled.baseBackgroundColor = .AlfaBlue
        filled.attributedTitle = AttributedString(title(for: .application)!, attributes: container)
        filled.titleAlignment = .trailing

        return filled
    }
}
