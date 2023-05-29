//
//  UserCell.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/29/23.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    var user:User?{
        didSet{configure()}
    }
    
    //MARK: Properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemPurple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "spiderman"
        return label
    }()
    
    private let fullnameLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Peter Parker"
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        profileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        profileImageView.setDimensions(height: 64, width: 64)
        profileImageView.layer.cornerRadius = 64 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLbl,fullnameLbl])
        stack.axis = .vertical
        stack.spacing = 2
        
        contentView.addSubview(stack)
        stack.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helper
    func configure(){
        guard let user = user else {return}
        fullnameLbl.text = user.fullname
        usernameLbl.text = user.username
        
        guard let url = URL(string: user.profileImageUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
}
