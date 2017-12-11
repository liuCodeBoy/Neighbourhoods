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
    
    var followingList = [AttentionAndFansModel]()
    
    var progressView: UIView?
    
    var uid: NSNumber?

    lazy var coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowersTableView.delegate = self
        myFollowersTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "他的粉丝")
        
        loadFollowingUsers()

    }

    func loadFollowingUsers() {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
        
        if uid == nil {
            self.uid = UserDefaults.standard.integer(forKey: "uid") as NSNumber
            self.setNavBarTitle(title: "我的粉丝")
        }
        
        NetWorkTool.shareInstance.userFans(access_token, uid: uid as! Int) { [weak self](result, error) in
            
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                guard let dictArray = result?["result"] as? [NSDictionary] else {
                    return
                }
                for userDict in dictArray {
                    if let listModel = AttentionAndFansModel.mj_object(withKeyValues: userDict["user"]) {
                        self?.followingList.append(listModel)
                    }
                }
                self?.myFollowersTableView.reloadData()
                
                if let count = self?.followingList.count {
                    if CGFloat(count) == 0 {
                        self?.coverView.showLab.text = "暂无粉丝"
                        self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                        self?.view.addSubview((self?.coverView)!)
                    }
                }
            } else if result!["code"] as! String == "400" {
                    self?.coverView.showLab.text = "暂无粉丝"
                    self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    self?.view.addSubview((self?.coverView)!)
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
