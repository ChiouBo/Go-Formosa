//
//  TrailTypeObject.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/4.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

// MARK: - TrailTypeElement
struct TrailType: Codable {
    let trailid, trCname: String
    let trTyp: TrTyp
    let title, content, annDate, opendate: String
    let closedate: String
    let trSub: TrSub
    let depName: String

    enum CodingKeys: String, CodingKey {
        case trailid = "TRAILID"
        case trCname = "TR_CNAME"
        case trTyp = "TR_TYP"
        case title = "TITLE"
        case content = "CONTENT"
        case annDate = "ANN_DATE"
        case opendate, closedate
        case trSub = "TR_SUB"
        case depName = "DEP_NAME"
    }
}
// swiftlint:disable identifier_name redundant_string_enum_value
enum TrSub: String, Codable {
    case 全線 = "全線"
    case 其他 = "其他"
    case 西段 = "西段"
}

enum TrTyp: String, Codable {
    case 暫停開放 = "暫停開放"
    case 注意 = "注意"
    case 部分封閉 = "部分封閉"
}

typealias AllTrailType = [TrailType]
