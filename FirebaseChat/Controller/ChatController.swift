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

    //MARK: Helper
    func configureUI(){
        collectionView.backgroundColor = .white
        print("User to chat is \(user.fullname)")
    }
    
    //MARK: Selector


}
