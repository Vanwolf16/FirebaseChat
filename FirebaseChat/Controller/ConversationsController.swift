//
//  ConversationsController.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/25/23.
//

import UIKit

class ConversationsController: UIViewController {
    //MARK: Properties
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: Helpers
    func configureUI(){
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
    }
    
    //MARK: Selector
    @objc func showProfile(){
        print("Hello Profile")
    }
    
}
