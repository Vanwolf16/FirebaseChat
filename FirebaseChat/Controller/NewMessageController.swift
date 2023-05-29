//
//  NewMessageController.swift
//  FirebaseChat
//
//  Created by David Murillo on 5/29/23.
//

import UIKit

class NewMessageController: UITableViewController {
    //MARK: Properties
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Helper
    
    //MARK: Selector
    func configureUI(){
        view.backgroundColor = .systemRed
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
