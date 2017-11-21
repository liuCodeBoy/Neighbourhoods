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
    
    let coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowingsTableView.delegate = self
        myFollowingsTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "我的关注")
        
        loadFollowingUsers()
        
        coverView.showLab.text = "暂无关注"
        coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.view.addSubview(coverView)
        
    }
    
    func loadFollowingUsers() {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.userAttention(access_token) { [weak self](result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                let dictArray = result!["result"] as! [[String : AnyObject]]
                for userDict in dictArray {
                    if let listModel = AttentionAndFansModel.mj_object(withKeyValues: userDict["user"]) {
                        self?.followingList.append(listModel)
                    }
                }
                self?.myFollowingsTableView.reloadData()
                if CGFloat((self?.followingList.count)!) > 0 {
                    self?.coverView.removeFromSuperview()
                }
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
