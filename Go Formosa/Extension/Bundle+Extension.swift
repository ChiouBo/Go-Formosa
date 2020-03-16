//
//  Bundle+Extension.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

extension Bundle {
    // swiftlint:disable force_cast
    static func GHValueForString(key: String) -> String {
        
        return Bundle.main.infoDictionary![key] as! String
    }

    static func GHValueForInt32(key: String) -> Int32 {

        return Bundle.main.infoDictionary![key] as! Int32
    }
    // swiftlint:enable force_cast
}
