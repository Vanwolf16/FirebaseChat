//
//  ProfileController.swift
//  FirebaseChat
//
//  Created by David Murillo on 6/9/23.
//

import UIKit
import Firebase

private let reuseIdentifer = "ProfileCell"

protocol ProfileControllerDelegate:AnyObject{
    func handleLogout()
}

class ProfileController: UITableViewController {
    
    weak var delegate:ProfileControllerDelegate?
    
    //MARK: Properties
    private var user:User?{
        didSet{headerView.user = user}
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 380))
    
    private let footerView = ProfileFooter()
    
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
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        
        footerView.delegate = self
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
    }

}
//MARK: Delegate and Datasource
extension ProfileController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as? ProfileCell else {return UITableViewCell()}
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    //Did Select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else {return}
        
        switch viewModel {
        case .accountInfo:
            print("DEBUG: Show account info page..")
        case .settings:
            print("DEBUG: Show settings page..")
        }
        
    }
    
}

extension ProfileController:ProfileFooterDelegate{
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure want to logout?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive,handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        present(alert, animated: true)
        
    }
    
    
}

extension ProfileController:ProfileHeaderViewDelegate{
    func dismissController() {
        dismiss(animated: true)
    }
    
}
