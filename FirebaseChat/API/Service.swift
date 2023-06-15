//
//  Service.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/29/23.
//

import Firebase

struct Service{
    
    static func fetchUsers(completion: @escaping([User]) -> Void){
        //var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            guard var users = snapshot?.documents.map({ User(dictionary: $0.data())}) else {return}
            //It Removes the currentUsers on the list
            if let i = users.firstIndex(where: {$0.uid == Auth.auth().currentUser?.uid}){
                users.remove(at: i)
            }
            
            completion(users)
        }
    }
    
    //MARK: USER
    static func fetchUser(withUid uid:String, completion: @escaping(User) -> Void){
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
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
            
            COLLECTIONMESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            
            COLLECTIONMESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
            
        }
       
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void){
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTIONMESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
        
    }
    
}
