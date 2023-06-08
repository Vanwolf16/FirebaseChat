//
//  ConversationCell.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/26/23.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    //MARK: Properties
    var conversations:Conversation?{
        didSet{configure()}
    }
    
    let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let usernameLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let timestampLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let messageTextLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor,paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLbl,messageTextLbl])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor,
        paddingLeft: 12,paddingRight: 16)
        
        addSubview(timestampLbl)
        timestampLbl.anchor(top: topAnchor,right: rightAnchor,paddingTop: 20,paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper
    func configure(){
        guard let conversation = conversations else {return}
        let viewModel = ConversationViewModel(conversation: conversation)
        
        usernameLbl.text = conversation.user.username
        messageTextLbl.text = conversation.message.text
        
        timestampLbl.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
    }
}
