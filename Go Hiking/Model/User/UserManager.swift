//
//  UserManager.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/31.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

enum FirebaseLogin: Error {
    
    case noneLogin
}

class UserManager {
    
    private init () { }
    
    static let share = UserManager()
    
    let userDB = Firestore.firestore()
    
    var userInfo: UserInfo?
    
    // MARK: - Save User Info in Database
    func saveUserData(completion: @escaping (Result<String>) -> Void) {
        
        guard let name = Auth.auth().currentUser?.displayName,
            let id = Auth.auth().currentUser?.uid,
            let email = Auth.auth().currentUser?.email,
            let picture = Auth.auth().currentUser?.photoURL?.absoluteString else {
                return
        }
        let image = "?width=400&height=400"
        
        let pictureString = "\(picture + image)"
        
        let userInfo = UserInfo(id: id, name: name, email: email, picture: pictureString, introduction: "", coverImage: "", userLocation: "", eventCreate: [], event: [])
        
        self.userDB.collection("users").document(id).setData(userInfo.todict){ (error) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
            
            completion(.success("SaveUserData"))
        }
        
    }
    
    // MARK: - Save Users Auth
    func signinUserData(credential: AuthCredential, completion: @escaping (Result<String>) -> Void) {
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            if let error = error {
                
                print("Login error: \(error.localizedDescription)")
                
            }
            completion(.success("SigninUserData"))
        }
    }
    
    // MARK: - Download Users Info
    func loadUserInfo(completion: @escaping (Swift.Result<UserInfo, Error>) -> Void ) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userDB.collection("users").document(uid).getDocument { (user, error) in
            
            guard let user = user, error == nil else {
                return
            }
            
            do {
                guard let info = try user.data(as: UserInfo.self, decoder: Firestore.Decoder()) else {
                    completion(.failure(FirebaseLogin.noneLogin))
                    return
                }
                completion(.success(info))
            } catch {
                
                print("\(error.localizedDescription)")
                
                completion(.failure(FirebaseLogin.noneLogin))
            }
        }
    }
    
    // MARK: - Upload Users Data
    func uploadUserData(userInfo: UserInfo, completion: @escaping (Result<String>) -> Void ) {
        
        userDB.collection("users").document(userInfo.id).setData(userInfo.todict) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("success"))
            }
        }
    }
    
    // MARK: - Upload Record Data
    func saveRecordData(userRecord: UserRecord, completion: @escaping (Result<String>) -> Void ) {
        
        let pathID = userDB.collection("users").document(userRecord.id).collection("Path").document().documentID
        
        do{
            try userDB.collection("users").document(userRecord.id).collection("Path").document(pathID).setData(from: userRecord)
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Download Record Data
    func loadRecordData(completion: @escaping (Result<[UserRecord]>) -> Void ) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userDB.collection("users").document(uid).collection("Path").order(by: "date", descending: true).getDocuments { (snapshot, error) in
            
            var recordData: [UserRecord] = []
            
            if error == nil && snapshot?.documents.count != 0 {
                
                for document in snapshot!.documents {
                    
                    do {
                        guard let data = try document.data(as: UserRecord.self, decoder: Firestore.Decoder()) else { return }
                        
                        recordData.append(data)
                        
                    } catch {
                        
                        print(error)
                    }
                }
                completion(.success(recordData))
            }
        }
    }
}


