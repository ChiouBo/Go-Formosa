//
//  UserObject.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import Firebase
import AuthenticationServices

struct UserObject: Codable {

    let accessToken: String
    
    let user: UserInfo
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

struct UserInfo: Codable {
    
    let id: String
    
    let name: String
    
    let email: String
    
    let picture: String
    
    var introduction: String?
    
    var coverImage: String?
    
    var userLocation: String?
    
    var eventCreate: [DocumentReference]
    
    var event: [DocumentReference]
    
    var todict: [String: Any] {
        
        return [
            "id": id,
            
            "name": name,
            
            "email": email,
            
            "picture": picture,
            
            "introduction": introduction ?? "",
            
            "coverImage": coverImage ?? "",
            
            "userLocation": userLocation ?? "",
            
            "eventCreate": eventCreate,
            
            "event": event
        ]
    }
}

struct UserRecord: Codable {
    
    let id: String
    
    let date: String
    
    let distance: Double
    
    let time: Int
     
    let markerLat: [Double]
    
    let markerLong: [Double]
    
    let lineImage: String
    
    var recordDict: [String: Any] {

        return [

            "id": id,

            "date": date,

            "distance": distance,

            "time": time,

            "markerLat": markerLat,
            
            "markerLong": markerLong,

            "lineImage": lineImage
        ]
    }
    
}

struct AppleUser {
    
    let id: String
    
    let firstName: String
    
    let lastName: String
    
    let email: String
    
    @available(iOS 13.0, *)
    init(credentials: ASAuthorizationAppleIDCredential) {
        
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
}

extension AppleUser: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return """
        ID: \(id)
        First Name: \(firstName)
        Last Name: \(lastName)
        Email: \(email)
        """
    }
}

struct UserRequest: Codable {
    
    let id: String
    
    let name: String
    
    let email: String
    
    let photo: String
    
    let respond: Bool
    
    var requestDict: [String: Any] {
        
        return [
            
            "id": id,
            
            "name": name,
            
            "email": email,
            
            "photo": photo,
            
            "respond": respond
        ]
    }
}
