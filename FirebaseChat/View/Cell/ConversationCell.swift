//
//  ConversationCell.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/26/23.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    //MARK: Properties
    let usernameLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(usernameLbl)
        usernameLbl.anchor(top: topAnchor,left: leftAnchor,paddingTop: 5,paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper
}
