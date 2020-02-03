//
//  UIColor+Extension.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/1.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

private enum GHColor: String {

    // swiftlint:disable identifier_name
    case G1

    case T1

    case T2

    case T3

    case T4

    case T5
    
    case Denim
    
    case Facebook
    
}

extension UIColor {

    static let G1 = GHColor(.G1)

    static let T1 = GHColor(.T1)
    
    static let T2 = GHColor(.T2)
    
    static let T3 = GHColor(.T3)
    
    static let T4 = GHColor(.T4)

    static let T5 = GHColor(.T5)

    static let Denim = GHColor(.Denim)

    static let Facebook = GHColor(.Facebook)
    
    // swiftlint:enable identifier_name
    
    private static func GHColor(_ color: GHColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
