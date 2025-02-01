//
//  EdgeBorder.swift
//  JobLoyal
//
//  Created by Sina khanjani on 12/13/1399 AP.
//

import SwiftUI

/// This class `EdgeBorder` is used to manage specific logic in the application.
struct EdgeBorder: Shape {

/// This variable `width` is used to store a specific value in the application.
    var width: CGFloat
/// This variable `edges` is used to store a specific value in the application.
    var edges: [Edge]

/// This method `path` is used to perform a specific operation in a class or struct.
    func path(in rect: CGRect) -> Path {
/// This variable `path` is used to store a specific value in the application.
        var path = Path()
        for edge in edges {
/// This variable `x` is used to store a specific value in the application.
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

/// This variable `y` is used to store a specific value in the application.
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

/// This variable `w` is used to store a specific value in the application.
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

/// This variable `h` is used to store a specific value in the application.
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}
