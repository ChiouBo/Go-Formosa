//
//  TrailObject.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/3.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

struct Trail: Codable {
    let trailid, trCname, trClass, trMainSys: String
    let trSubSys: String?
    let trAdmin: TrAdmin
    let trAdminPhone: String
    let trPosition, guideContent: String?
    let trEntrance: [TrEntrance]
    let trLength: String
    let trLengthNum: Double?
    let trAlt: String?
    let trAltLow: Int?
    let trPave, trDIFClass, trTour: String?
    let trBestSeason: TrBestSeason?
    let trSpecial: String?
    let car, mBus, lBus: Int?
    let trHutName: String?
    let trPermit: TRPermit?
    let url: String
    var photo: String?

    enum CodingKeys: String, CodingKey {
        case trailid = "TRAILID"
        case trCname = "TR_CNAME"
        case trClass = "TR_CLASS"
        case trMainSys = "TR_MAIN_SYS"
        case trSubSys = "TR_SUB_SYS"
        case trAdmin = "TR_ADMIN"
        case trAdminPhone = "TR_ADMIN_PHONE"
        case trPosition = "TR_POSITION"
        case guideContent = "GUIDE_CONTENT"
        case trEntrance = "TR_ENTRANCE"
        case trLength = "TR_LENGTH"
        case trLengthNum = "TR_LENGTH_NUM"
        case trAlt = "TR_ALT"
        case trAltLow = "TR_ALT_LOW"
        case trPave = "TR_PAVE"
        case trDIFClass = "TR_DIF_CLASS"
        case trTour = "TR_TOUR"
        case trBestSeason = "TR_BEST_SEASON"
        case trSpecial = "TR_SPECIAL"
        case car = "CAR"
        case mBus = "M_BUS"
        case lBus = "L_BUS"
        case trHutName = "TR_HUT_NAME"
        case trPermit = "TR_permit"
        case url = "URL"
    }
}

// swiftlint:disable identifier_name redundant_string_enum_value
enum TrAdmin: String, Codable {
    case 南投林區管理處 = "南投林區管理處"
    case 南投林區管理處花蓮林區管理處 = "南投林區管理處\u{d}\n花蓮林區管理處"
    case 台東林區管理處 = "台東林區管理處"
    case 嘉義林區管理處 = "嘉義林區管理處"
    case 屏東林區管理處 = "屏東林區管理處"
    case 屏東林區管理處台東林區管理處 = "屏東林區管理處\n台東林區管理處"
    case 新竹林區管理處 = "新竹林區管理處"
    case 東勢林區管理處 = "東勢林區管理處"
    case 羅東林區管理處 = "羅東林區管理處"
    case 花蓮林區管理處 = "花蓮林區管理處"
}

enum TrBestSeason: String, Codable {
    case empty = ""
    case the56月 = "5、6月"
    case 五六月 = "五、六月"
    case 全年 = "全年"
    case 全年皆宜 = "全年皆宜"
    case 四季 = "四季"
    case 四季皆宜 = "四季皆宜"
    case 春 = "春"
    case 春夏季節氣候穩定觀星賞月看日出或黃昏時漁船滿載歸航都是絕佳的視覺享受 = "春夏季節氣候穩定，觀星、賞月、看日出，或黃昏時漁船滿載歸航，都是絕佳的視覺享受。"
    case 秋冬季 = "秋冬季"
    case 秋季 = "秋季"
}

// MARK: - TrEntrance
struct TrEntrance: Codable {
    let height: Int?
    let x, y: Double?
    let memo: String?
}

enum TRPermit: String, Codable {
    case 乙種 = "乙種"
    case 山地 = "山地"
    case 無 = "無"
    case 甲種 = "甲種"
}

typealias AllTrail = [Trail]
