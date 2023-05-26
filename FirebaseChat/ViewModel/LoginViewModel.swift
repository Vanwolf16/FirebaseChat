//
//  LoginViewModel.swift
//  ChatFire
//
//  Created by David Murillo .
//

import UIKit

struct LoginViewModel{
    var email:String?
    var password:String?
    
    var formIsValid:Bool{
        return email?.isEmpty == false &&
            password?.isEmpty == false
    }
    
}
