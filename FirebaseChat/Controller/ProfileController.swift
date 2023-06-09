//
//  ProfileController.swift
//  FirebaseChat
//
//  Created by David Murillo on 6/9/23.
//

import UIKit
import Firebase

private let reuseIdentifer = "ProfileCell"

class ProfileController: UITableViewController {
    //MARK: Properties
    private var user:User?{
        didSet{headerView.user = user}
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 380))
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: Selector
    
    //MARK: API
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            print("DEBUG: User is \(user.username)")
        }
    }
    
    //MARK: Helpers
    func configureUI(){
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
    }

}
//MARK: Delegate and Datasource
extension ProfileController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        
        return cell
    }
}

extension ProfileController:ProfileHeaderViewDelegate{
    func dismissController() {
        dismiss(animated: true)
    }
    
}
