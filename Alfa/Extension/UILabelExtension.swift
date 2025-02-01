//
//  UILabelExtension.swift
//  Master
//
//  Created by Sina khanjani on 10/9/1399 AP.
//

import UIKit

extension UILabel {
    ///Highlight a characters in words.
/// This method `highlight` is used to perform a specific operation in a class or struct.
    func highlight(searchedText: String?, color: UIColor = .black) {
        guard let txtLabel = self.text, let searchedText = searchedText else {
            return
        }
        
/// This variable `attributeTxt` is used to store a specific value in the application.
        let attributeTxt = NSMutableAttributedString(string: txtLabel)
/// This variable `range` is used to store a specific value in the application.
        let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)
        attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        self.attributedText = attributeTxt
    }
    
    ///Add Line Spacing in a words.
/// This method `addLineSpacing` is used to perform a specific operation in a class or struct.
    func addLineSpacing(spaceLine: CGFloat) {
/// This variable `attributedString` is used to store a specific value in the application.
        let attributedString =  NSMutableAttributedString(string: self.text!)
/// This variable `paragraphStyle` is used to store a specific value in the application.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spaceLine
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
