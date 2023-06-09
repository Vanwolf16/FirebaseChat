//
//  ProfileHeader.swift
//  FirebaseChat
//
//  Created by David Murillo on 6/9/23.
//

import UIKit

protocol ProfileHeaderViewDelegate:AnyObject{
    func dismissController()
}

class ProfileHeader:UIView{
    //MARK: Properties
    var user:User?{
        didSet{populateUserData()}
    }
    
    weak var delegate:ProfileHeaderViewDelegate?
    
    private let dismissBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmas"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    private let profileImageView:UIImageView = {
       let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Eddie Brock"
        return label
    }()
    
    private let usernameLbl:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "@venom"
        return label
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helper
    func configureUI(){
        backgroundColor = .systemPurple
        
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor,paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLbl,usernameLbl])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor,paddingTop: 16)
        addSubview(dismissBtn)
        dismissBtn.anchor(top: topAnchor,left: leftAnchor,paddingTop: 44,paddingLeft: 12)
        dismissBtn.setDimensions(height: 48, width: 48)
    }
    
    func populateUserData(){
        guard let user = user else {return}
        
        fullnameLbl.text = user.fullname
        usernameLbl.text = "@" + user.username
        
        guard let url = URL(string: user.profileImageUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
    
    //MARK: Selector
    @objc func handleDismissal(){
        delegate?.dismissController()
    }
}
