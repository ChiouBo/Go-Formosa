//
//  UserManager.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/31.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserManager {
    
    private init () { }
    
    static let share = UserManager()
    
    let userDB = Firestore.firestore()
    
    func saveUserData(completion: @escaping (Result<String>) -> Void) {
        
        guard let name = Auth.auth().currentUser?.displayName,
            let id = Auth.auth().currentUser?.uid,
            let email = Auth.auth().currentUser?.email,
            let picture = Auth.auth().currentUser?.photoURL?.absoluteString else {
                return
                
        }
        
        let pictureString = "\(picture)"
        
        let userInfo = User(id: id, name: name, email: email, picture: pictureString)
        
        self.userDB.collection("users").document(id).setData(userInfo.todict){ (error) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
            
            completion(.success("SaveUserData"))
        }
        
    }
    
    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
    
    func signinUserData(completion: @escaping (Result<String>) -> Void) {
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            if let error = error {
                
                print("Login error: \(error.localizedDescription)")
                
            }
            
//            print(authResult?.user.email)
            
            completion(.success("SigninUserData"))
        }
        
    }
    
}


