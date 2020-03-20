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
    
    // MARK: - Store Photo at Storage & Download Photo URL
    func storage(uniqueString: String, data: Data, completion: @escaping (Result<URL>) -> Void ) {
        // swiftlint:disable unused_closure_parameter
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
    func removeEvent(event: String, completion: @escaping (Result<Void>) -> Void) {
        
        eventDB.collection("Event").document(event).delete { (error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Making Request to Event
    func requestEvent(userRequest: UserInfo, event: EventCurrent, completion: @escaping (Result<String>) -> Void ) {
        
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        let ref: DocumentReference = eventDB.collection("Users").document(userUid)
        
        eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayUnion([ref])])
        
        eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayUnion([userUid])])
        
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
    
    // MARK: - Upload Member to Event
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
    
    // MARK: - Bring Waitinglist to Mamberlist
    func acceptRequestUser(event: EventCurrent, uid: String, completion: @escaping (Result<Void>) -> Void ) {
        
        let ref = eventDB.collection("Users").document(uid)
        
        let eventRef = eventDB.collection("Event").document(event.eventID)
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayRemove([ref])])
        
        eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayRemove([ref])])
        
        eventDB.collection("Event").document(event.eventID).updateData(["memberList": FieldValue.arrayUnion([ref])])
        
        eventDB.collection("Users").document(uid).updateData(["event": FieldValue.arrayUnion([eventRef])])
        
        eventDB.collection("Users").document(currentUid).updateData(["eventCreate": FieldValue.arrayUnion([eventRef])])
        
        completion(.success(()))
    }
    
    // MARK: - Delete Member
    func deleteMember(event: EventCurrent, uid: String, completion: @escaping (Result<Void>) -> Void ) {
        
        let ref = eventDB.collection("Users").document(uid)
        
        eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayRemove([ref.documentID])])
        
        eventDB.collection("Event").document(event.eventID).updateData(["memberList": FieldValue.arrayRemove([ref])]) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Reject Request
    func deleteRequest(event: EventCurrent, uid: String, completion: @escaping (Result<Void>) -> Void ) {
        
        let ref = eventDB.collection("Users").document(uid)
        
        eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayRemove([ref])]) { (error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Create Chatroom
    func creatChatRoom(chatroomID: String, eventID: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        
        let channel = Channel(name: chatroomID, eventID: eventID)
        
        eventDB.collection("Chatroom").document(chatroomID).setData(channel.representation) { (_) in
            
            completion(.success("Chatroom build"))
        }
    }
}
