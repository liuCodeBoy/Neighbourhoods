//
//  FavUsersListViewController.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/16.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

class FavUsersListViewController: UIViewController {
    
    @IBOutlet weak var followingsTableView: UITableView!
    
    private var followingList = [AttentionAndFansModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followingsTableView.delegate = self
        followingsTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "我的关注")
        
        loadFollowingUsers()
        
    }
    
    func loadFollowingUsers() {
        
        let token = UserDefaults.standard.string(forKey: "token")
        NetWorkTool.shareInstance.userAttention(token!) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                let dictArray = result!["result"] as! [[String : AnyObject]]
                for userDict in dictArray {
                    if let listModel = AttentionAndFansModel.mj_object(withKeyValues: userDict["user"]) {
                        self.followingList.append(listModel)
                    }
                }
                self.followingsTableView.reloadData()
            } else {
                print("post failed with code \(String(describing: result!["code"]))")
            }
        }
    }
    
    
}

extension FavUsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavUsersListCell") as! FavUsersListTableViewCell
        cell.viewModel = followingList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
}

