//
//  NewMessageController.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/29/23.
//

import UIKit

private let reuseId = "UserCell"

protocol NewMessageControllerDelegate:AnyObject{
    func controller(_ controller:NewMessageController, wantsToStartChatWith user:User)
}

class NewMessageController: UITableViewController {
    //MARK: Delegate
    weak var delegate: NewMessageControllerDelegate?
    
    //MARK: Properties
    private var users = [User]()
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    //MARK: API
    func fetchUsers(){
        Service.fetchUsers { user in
            self.users = user
            self.tableView.reloadData()
        }
    }
    
    //MARK: Helper
    func configureUI(){
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseId)
        tableView.rowHeight = 80
    }
    //MARK: Selector
    @objc func handleDismissal(){
        dismiss(animated: true)
    }

}
//MARK: DataSource and Delegate
extension NewMessageController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? UserCell else {return UITableViewCell()}
        cell.user = users[indexPath.row]
        return cell
    }
}

extension NewMessageController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
    }
}
