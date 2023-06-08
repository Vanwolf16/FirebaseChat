//
//  ChatController.swift
//  FirebaseChat
//
//  Created by David Murillo on 6/7/23.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChatController: UICollectionViewController {
    
    //MARK: Properties
    private let user:User
    
    private lazy var customInputView:CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        
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
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
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
        print("User to chat is \(user.fullname)")
    }
    
    //MARK: Selector


}
