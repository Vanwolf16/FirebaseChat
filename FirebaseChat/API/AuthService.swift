//
//  AuthService.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/27/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit
import FirebaseStorage

struct RegistrationCredentials{
    let email:String
    let password:String
    let fullname:String
    let username:String
    let profileImage:UIImage
}

struct AuthService{
    static let shared = AuthService()
    
    func logUserIn(withEmail email:String, password:String,completion:((AuthDataResult?, Error?) -> Void)?){
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
    
    func createUser(credentials:RegistrationCredentials,completion:((Error?) -> Void)?){
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData,metadata: nil) { meta, error in
            if let error = error{
                print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    if let error = error{
                        print("DEBUG: failed to create the user: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let data = ["email":credentials.email,
                                "fullname":credentials.fullname,
                                "profileImageUrl":profileImageUrl,
                                "uid":uid,
                                "username":credentials.username] as [String:Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data,completion: completion)
                    
                }//end of Auth Create User
                
            }//end of downloadURL
            
        }//end of putData
        
    }
    
}
