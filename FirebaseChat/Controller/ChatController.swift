//
//  ChatController.swift
//  FirebaseChat
//
//  Created by David Murillo on 6/7/23.
//

import UIKit

private let reuseIdentifier = "MessageCell"

class ChatController: UICollectionViewController {
    
    //MARK: Properties
    private let user:User
    private var messages = [Message]()
    
    
    private lazy var customInputView:CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    //MARK: Lifecycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
       fetchMessages()
        
    }
    
    //MARK: API
    func fetchMessages(){
        Service.fetchMessages(forUser: user) { messages in
            self.messages = messages
            self.collectionView.reloadData()
        }
    }
    
    override var inputAccessoryView: UIView?{
        get {return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
    }
    
    //MARK: Helper
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
    //MARK: Selector


}

extension ChatController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else {return UICollectionViewCell()}
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}

extension ChatController: CustomInputAccessoryViewDelegate{
    func inputView(_ inputView: CustomInputAccessoryView, wantToSend message: String) {
        Service.uploadMessage(message, to: user) { error in
            if let error = error{
                print("DEBUG: Failed to upload message with error \(error.localizedDescription)")
                return
            }
            
            inputView.clearMessageText()
        }
    }
    
    
}
