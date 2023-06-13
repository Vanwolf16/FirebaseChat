//
//  ProfileFooter.swift
//  FirebaseChat
//
//  Created by David Murillo on 6/13/23.
//

import UIKit

protocol ProfileFooterDelegate:AnyObject{
    func handleLogout()
}

class ProfileFooter:UIView{
    
    weak var delegate:ProfileFooterDelegate?
    
    //MARK: Properties
    private lazy var logoutButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor,right: rightAnchor,paddingLeft: 32,paddingRight: 32)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleLogout(){
        delegate?.handleLogout()
    }
    //MARK: Helper
}
