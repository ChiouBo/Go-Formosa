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
    
    var userInfo: User?
    
    func saveUserData(completion: @escaping (Result<String>) -> Void) {
        
        guard let name = Auth.auth().currentUser?.displayName,
            let id = Auth.auth().currentUser?.uid,
            let email = Auth.auth().currentUser?.email,
            let picture = Auth.auth().currentUser?.photoURL?.absoluteString else {
                return
        }
        let image = "?width=400&height=400"
        
        let pictureString = "\(picture + image)"
        
        let userInfo = User(id: id, name: name, email: email, picture: pictureString, introduction: "", coverImage: "", userLocation: "")
        
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
            completion(.success("SigninUserData"))
        }
    }
    
    func loadUserInfo(completion: @escaping (Result<User>) -> Void ) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userDB.collection("users").document(uid).getDocument { (user, error) in
            
            guard let user = user, error == nil else {
                return
            }
            
            do {
                guard let info = try user.data(as: User.self, decoder: Firestore.Decoder()) else {
                    return
                }
                completion(.success(info))
            } catch {
                
                print("\(error.localizedDescription)")
                
                completion(.failure(error))
            }
        }
    }
    
    func uploadUserData(userInfo: User, completion: @escaping (Result<String>) -> Void ) {
        
        userDB.collection("users").document(userInfo.id).setData(userInfo.todict) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("success"))
            }
        }
    }
}


