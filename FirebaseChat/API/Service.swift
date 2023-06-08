//
//  Service.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/29/23.
//

import Firebase

struct Service{
    
    static func fetchUsers(completion: @escaping([User]) -> Void){
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func fetchMessages(forUser user:User,completion:@escaping([Message]) -> Void){
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let query = COLLECTIONMESSAGES.document(currentUid).collection(user.uid)
            .order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added{
                    let dictornary = change.document.data()
                    messages.append(Message(dictionary: dictornary))
                    completion(messages)
                }
            })
        }
    }
    
   static func uploadMessage(_ message:String, to user:User,completion:((Error?) -> Void)?){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text":message,
                    "fromId":currentUid,
                    "toId":user.uid,
                    "timestamp":Timestamp(date: Date())] as [String:Any]
        
        COLLECTIONMESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            COLLECTIONMESSAGES.document(user.uid).collection(currentUid).addDocument(data: data,completion: completion)
        }
        
    }
    
}
