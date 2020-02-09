//
//  GradientColor+Extension.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    
    private init() { }
    
    static let gradient = Gradient()
}

struct Gradient {
    
    let gradientLayer = [UIColor.red.cgColor, UIColor.yellow.cgColor]
    
}
