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
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
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
        
        configureSearchController()
    }
    
    func configureSearchController(){
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField{
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
        
        searchController.searchResultsUpdater = self
    }
    
    //MARK: Selector
    @objc func handleDismissal(){
        dismiss(animated: true)
    }

}
//MARK: DataSource and Delegate
extension NewMessageController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? UserCell else {return UITableViewCell()}
        //cell.user = users[indexPath.row]
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        return cell
        
        
    }
}

extension NewMessageController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantsToStartChatWith: user)
    }
}

extension NewMessageController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({ user in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        
        self.tableView.reloadData()
    }
    
    
}
