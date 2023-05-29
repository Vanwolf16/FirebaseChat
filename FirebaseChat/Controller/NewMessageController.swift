//
//  NewMessageController.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/29/23.
//

import UIKit

private let reuseId = "UserCell"

class NewMessageController: UITableViewController {
    //MARK: Properties
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? UserCell else {return UITableViewCell()}
        
        return cell
    }
}
