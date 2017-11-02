//
//  MyFollowersViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyFollowersViewController: UIViewController {
    
    @IBOutlet weak var myFollowersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowersTableView.delegate = self
        myFollowersTableView.dataSource = self
        myFollowersTableView?.register(UINib(nibName: "UsersListTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersListCell")

        
        setNavBarBackBtn()
        setNavBarTitle(title: "我的粉丝")
    }


}

extension MyFollowersViewController: UITableViewDelegate, UITableViewDataSource {
    
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
