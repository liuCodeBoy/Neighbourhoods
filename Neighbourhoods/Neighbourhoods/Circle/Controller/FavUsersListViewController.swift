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
    let coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    private var followingList = [AttentionAndFansModel]()
    
    var uid: NSNumber?
    
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
        if uid == nil {
            self.uid = UserDefaults.standard.integer(forKey: "uid") as NSNumber
        }
        NetWorkTool.shareInstance.userAttention(token!, uid: uid as! Int) { [weak self](result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                guard let dictArray = result?["result"] as? [NSDictionary] else {
                        self?.coverView.showLab.text = "暂无关注"
                        self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    self?.followingsTableView.addSubview((self?.coverView)!)
                    return
                }
                for userDict in dictArray {
                    if let listModel = AttentionAndFansModel.mj_object(withKeyValues: userDict["user"]) {
                        self?.followingList.append(listModel)
                    }
                }
                self?.followingsTableView.reloadData()
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
        guard self.followingList.count > 0  else{
            return cell
        }
        cell.viewModel = followingList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }
    
}

