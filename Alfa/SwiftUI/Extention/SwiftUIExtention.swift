//
//  SwiftUIExtention.swift
//  JobLoyal
//
//  Created by Sina khanjani on 12/13/1399 AP.
//

import SwiftUI

// MARK: - Font Extension
extension Font {
    
    enum IranSansWeight: String {
        case regular = "IRANSansX-Regular"
        case thin = "IRANSansX-Thin"
        case ultraThin = "IRANSansX-UltraLight"
        case light = "IRANSansX-Light"
        case medium = "IRANSansX-Medium"
        case demiBold = "IRANSansX-DemiBold"
        case bold = "IRANSansX-Bold"
        case extraBold = "IRANSansX-ExtraBold"
        case black = "IRANSansX-Black"
        
/// This variable `value` is used to store a specific value in the application.
        var value: String { rawValue }
    }
    
    /// Custom font: 'Avenir Next' font
    static func iranSans(_ weight: IranSansWeight, size: CGFloat) -> Font {
        if #available(iOS 14.0, *) {
            return .custom(weight.value, size: size)
        } else {
            return .system(size: size, weight: .medium)
        }
    }
}

// MARK: - Color Extention
extension Color {
    /// Color Assets
    static let AlfaBlue: Color = Color(.AlfaBlue)
}

// MARK: - View Extention
extension View {
    /// Custom edges border
/// This method `border` is used to perform a specific operation in a class or struct.
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
