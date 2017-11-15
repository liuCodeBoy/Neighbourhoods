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

    private var followingList = [AttentionAndFansModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowingsTableView.delegate = self
        myFollowingsTableView.dataSource = self
        
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
                self.myFollowingsTableView.reloadData()
            } else {
                print("post failed with code \(String(describing: result!["code"]))")
            }
        }
    }


}

extension MyFollowingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFollowingsCell") as! ProfileFollowingTableViewCell
        cell.viewModel = followingList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }

}
