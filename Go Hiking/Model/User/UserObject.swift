//
//  UserObject.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

struct UserObject: Codable {

    let accessToken: String
    
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

struct User: Codable {

    let id: Int

    let provider: String

    let name: String

    let email: String

    let picture: String
}
