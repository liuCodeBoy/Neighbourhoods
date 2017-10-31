//
//  MyFollowingsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyFollowingsViewController: UIViewController {

    @IBOutlet weak var myFollowingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowingsTableView.delegate = self
        myFollowingsTableView.dataSource = self
        myFollowingsTableView?.register(UINib(nibName: "UsersListTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersListCell")
        
    }


}

extension MyFollowingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenHeight, height: 15))
        header.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let top = UITableViewRowAction(style: .normal, title: "置顶") { (action, index) in
            print("top")
        }
        top.backgroundColor = following_top
        let delete = UITableViewRowAction(style: .normal, title: "删除") { (action, index) in
            print("delete")
        }
        delete.backgroundColor = following_delete
        
        return [delete, top]
    }
}