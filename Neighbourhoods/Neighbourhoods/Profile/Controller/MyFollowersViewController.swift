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
    
    private var followingList = [AttentionAndFansModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowersTableView.delegate = self
        myFollowersTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "我的粉丝")
        
        loadFollowingUsers()

    }

    func loadFollowingUsers() {
        
        let token = UserDefaults.standard.string(forKey: "token")
        NetWorkTool.shareInstance.userFans(token!) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                let dictArray = result!["result"] as! [[String : AnyObject]]
                for userDict in dictArray {
                    if let listModel = AttentionAndFansModel.mj_object(withKeyValues: userDict["user"]) {
                        self.followingList.append(listModel)
                    }
                }
                self.myFollowersTableView.reloadData()
            } else {
                print("post failed with code \(String(describing: result!["code"]))")
            }
        }
    }

}

extension MyFollowersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFollowersCell") as! ProfileFollowerTableViewCell
        cell.viewModel = followingList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
}
