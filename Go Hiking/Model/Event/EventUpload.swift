//
//  EventUpload.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class UploadEvent {
    
    private init() {}
    
    static let shared = UploadEvent()
    
    let storageReference = Storage.storage().reference()
    
    let eventDB = Firestore.firestore()
    
    // MARK: - Upload Event Data
    func uploadEventData(chatroomID: String, evenContent: EventContent, image: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let documentID = eventDB.collection("Event").document().documentID
        
        let channel = Channel(name: chatroomID, eventID: documentID)
        
        eventDB.collection("Chatroom").document(chatroomID).setData(channel.representation)
        
        eventDB.collection("Event").document(documentID).setData([
            
            "title": evenContent.title,
            "desc": evenContent.desc,
            "location": evenContent.location,
            "start": evenContent.start,
            "end": evenContent.end,
            "member": evenContent.amount,
            "image": image,
            "creater": uid,
            "eventID": documentID,
            "waitingList": [],
            "memberList": [],
            "requestList": [],
            "chatroomID": chatroomID
            
        ]) { (error) in
            
            if let error = error {
                
                print(error)
            }
        }
    }
    
    // MARK: - Download Photo URL
    func storage(uniqueString: String, data: Data, completion: @escaping (Result<URL>) -> Void ) {
        
        let uploadData = data
        
        let storageRef = Storage.storage().reference().child("GHEventPhotoUpload").child("\(uniqueString).jpg")
        
        storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
            
            if error != nil {
                
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                guard let downloadURL = url else {
                    return
                }
                
                completion(.success(downloadURL))
                
                print(downloadURL)
            }
        })
    }
    
    // MARK: - Download Event Data
    func download(completion: @escaping (Result<EventCurrent>) -> Void) {
        
        eventDB.collection("Event").order(by: "start", descending: true).getDocuments { (snapshot, error) in
            
            if error == nil && snapshot?.documents.count != 0 {
                
                for document in snapshot!.documents {
                    
                    do {
                        
                        guard let data = try document.data(as: EventCurrent.self) else { return }
                        
                        completion(.success(data))
                        
                    } catch {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - Download Private Event Data
    func loadPrivate(completion: @escaping (Result<EventCurrent>) -> Void ) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        eventDB.collection("Event").whereField("creater", isEqualTo: currentUser).order(by: "start", descending: true).getDocuments { (snapshot, error) in
            
            if error == nil && snapshot?.documents.count != 0 {
                
                for document in snapshot!.documents {
                    
                    do {
                        
                        guard let data = try document.data(as: EventCurrent.self) else { return }
                        
                        completion(.success(data))
                        
                    } catch {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - Remove Event Data
    func removePost() {
        
        
    }
    
    // MARK: - Request Event
    func requestEvent(userRequest: UserInfo, event: EventCurrent, completion: @escaping (Result<String>) -> Void ) {
        
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        let ref: DocumentReference = eventDB.collection("users").document(userUid)
        
//        do{
            //            try eventDB.collection("Event").document(event.eventID).collection("Request").document(userUid).setData(from: userRequest)
            eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayUnion([ref])])
            
            eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayUnion([userUid])])
//        } catch {
            
//            print(error.localizedDescription)
//        }
    }
    
    // MARK: - Upload Request to Event
    func loadRequestUserInfo(event: EventCurrent, completion: @escaping (Swift.Result<[UserInfo], Error>) -> Void) {

        print(event.eventID)
        
        var waitingMembers: [UserInfo] = []
        
        for count in 0 ..< event.waitingList.count {
            
            event.waitingList[count].getDocument { userinfo, error in
                
                if error == nil {
                    
                    guard let data = userinfo else { return }
                    
                    do {
                        guard let userData = try data.data(as: UserInfo.self, decoder: Firestore.Decoder()) else { return }
                       
                        waitingMembers.append(userData)
                        
                        if waitingMembers.count == event.waitingList.count {
 
                            completion(.success(waitingMembers))
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
  
    
    // MARK: - Load Member to Event
    func loadMemberUserInfo(event: EventCurrent, completion: @escaping (Swift.Result<[UserInfo], Error>) -> Void) {

          print(event.eventID)
                 
                 var acceptMembers: [UserInfo] = []
                 
                 for count in 0 ..< event.memberList.count {
                     
                     event.memberList[count].getDocument { userinfo, error in
                         
                         if error == nil {
                             
                             guard let data = userinfo else { return }
                             
                             do {
                                 guard let userData = try data.data(as: UserInfo.self, decoder: Firestore.Decoder()) else { return }
                                
                                 acceptMembers.append(userData)
                                 
                                 if acceptMembers.count == event.memberList.count {
          
                                     completion(.success(acceptMembers))
                                 }
                                 
                             } catch {
                                 completion(.failure(error))
                             }
                         }
                     }
                 }
      }
    
    // MARK: - Bring User to Event Mamber
    func acceptRequestUser(event: EventCurrent, uid: String, completion: @escaping (Result<Void>) -> Void ) {
        
        let ref = eventDB.collection("users").document(uid)
        
        let eventRef = eventDB.collection("Event").document(event.eventID)
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayRemove([ref])])
        
        eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayRemove([ref])])
        
        eventDB.collection("Event").document(event.eventID).updateData(["memberList": FieldValue.arrayUnion([ref])])
        
        eventDB.collection("users").document(uid).updateData(["event": FieldValue.arrayUnion([eventRef])])
        
        eventDB.collection("users").document(currentUid).updateData(["eventCreate": FieldValue.arrayUnion([eventRef])])
        
//        eventDB.collection("users").whereField("id", isEqualTo: uid).getDocuments { (snapshot, error) in
//
//            if error == nil {
//
//                guard let data = snapshot else { return }
//
//                do {
//                    guard var userData = try data.documents[0].data(as: UserInfo.self, decoder: Firestore.Decoder()) else { return }
//
////                    userData.event.append(eventRef)
//                    self.uploadUserEvent(uid: uid, ref: eventRef)
//
//                    completion(.success(()))
//
//                } catch {
//
//                    completion(.failure(error))
//                }
//            }
//        }
        // Request id
            completion(.success(()))
    }
    
//    func uploadUserEvent(uid: String, ref: DocumentReference) {
//        
//        eventDB.collection("users").document(uid).updateData(["event": FieldValue.arrayUnion([ref])])
//    }
    
    // MARK: - Delete Member
    func deleteMember(event: EventCurrent, uid: String, completion: @escaping (Result<Void>) -> Void ) {
        
        let ref = eventDB.collection("users").document(uid)
        
        eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayRemove([ref.documentID])])
        
        eventDB.collection("Event").document(event.eventID).updateData(["memberList": FieldValue.arrayRemove([ref])]) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Delete Request
    func deleteRequest(event: EventCurrent, uid: String, completion: @escaping (Result<Void>) -> Void ) {
        
        let ref = eventDB.collection("users").document(uid)
        
        eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayRemove([ref])]) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    //
    func creatChatRoom(chatroomID: String, eventID: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        
        let channel = Channel(name: chatroomID, eventID: eventID)
        
        eventDB.collection("Chatroom").document(chatroomID).setData(channel.representation) { (_) in
            
            completion(.success("Chatroom build"))
        }
    }
    
}

