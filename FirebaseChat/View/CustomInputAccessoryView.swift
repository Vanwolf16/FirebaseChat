//
//  CustomInputAccessoryView.swift
//  FirebaseChat
//
//  Created by David Murillo on 6/7/23.
//

import UIKit

class CustomInputAccessoryView:UIView{
    //MARK: Properties
    private let messageInputTextView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLbl:UILabel = {
       let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor,right: rightAnchor,paddingTop: 4,paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor,left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: sendButton.leftAnchor,paddingTop: 12,
        paddingLeft: 4,paddingBottom: 4,paddingRight: 8)
        
        addSubview(placeholderLbl)
        placeholderLbl.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placeholderLbl.centerY(inView: messageInputTextView)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    @objc func handleTextInputChange(){
        placeholderLbl.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    @objc func handleSendMessage(){
        print("DEBUG: Handle send message here..")
    }
}
