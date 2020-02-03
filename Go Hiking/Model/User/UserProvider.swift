//
//  UserProvider.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import FBSDKLoginKit

//typealias FacebookResponse = (Result<String>) -> Void

enum FacebookError: String, Error {
    
    case noToken = "登入 Facebook 發生錯誤！"
    
    case userCancel
    
    case denineEmailPermission = "請允許存取 Facebook email！"
}

enum GoHikingSignInError: Error {
    
    case noToken
}

class UserProvider {
    
    let decoder = JSONDecoder()
    
    func signIntoGoHiking(fbToken: String, completion: @escaping (Result<Void>) -> Void) {
      
    }
}
