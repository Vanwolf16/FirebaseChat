//
//  ConversationsController.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/25/23.
//

import UIKit
import FirebaseAuth

private let reuseIdentifer = "ConversationCell"

class ConversationsController: UIViewController {
    //MARK: Properties
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    
    private let newMessageBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"),for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemPurple
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessageController), for: .touchUpInside)
        return button
    }()
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    //MARK: API
    func fetchConversations(){
        Service.fetchConversations { conversations in
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
    
    func authenticateUser(){
        if Auth.auth().currentUser?.uid == nil{
            presentLoginScreen()
        }else{
            print("User id is \(Auth.auth().currentUser?.uid)")
        }
    }
    
    func logOut(){
        do{
            try Auth.auth().signOut()
            presentLoginScreen()
        }catch{
            print("Error to sign out")
        }
    }
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav,animated: true)
        }
    }
    
    //MARK: Helpers
    func configureUI(){
        view.backgroundColor = .white
        
        //configureNavigationBar()
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        //NewMessageBtn
        view.addSubview(newMessageBtn)
        newMessageBtn.setDimensions(height: 56, width: 56)
        newMessageBtn.layer.cornerRadius = 56 / 2
        newMessageBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingBottom: 16,paddingRight: 24)
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
    }
    
    func configureNavigationBar(){
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        
    }
    
    //MARK: Selector
    @objc func showProfile(){
        let controller = ProfileController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func showNewMessageController(){
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
}
//MARK: Delegate and DataSource
extension ConversationsController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as? ConversationCell else {return UITableViewCell()}
        cell.conversations = conversations[indexPath.row]
        return cell
    }
    
    //Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ConversationsController:NewMessageControllerDelegate{
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
    
    
}
