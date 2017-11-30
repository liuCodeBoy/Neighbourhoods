//
//  QuickViewMessgaesViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class QuickViewMessgaesViewController: UIViewController {
    
    private var pages = 1
    private var page  = 1
    

    var missionListArray = [MsgListModel]()
    var headMsgModel = MsgListModel()

    @IBOutlet weak var contactListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactListTableView.delegate    = self
        contactListTableView.dataSource  = self
        
//        contactListTableView.allowsMultipleSelection                = false
//        contactListTableView.allowsSelectionDuringEditing           = false
//        contactListTableView.allowsMultipleSelectionDuringEditing   = false
        
        lastedRequest(p: page)
        loadRefreshComponet()
    
    }

    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        contactListTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        contactListTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        contactListTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        contactListTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        self.page = 1
        self.missionListArray.removeAll()
        lastedRequest(p: page)
        contactListTableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }

        NetWorkTool.shareInstance.quickMessageMain(access_token, p: page) { [weak self](info, error) in

            
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
                }
                
                let dict = info!["result"]
                self?.headMsgModel = MsgListModel.mj_object(withKeyValues: dict)
                
                let result  = info!["result"]!["list"] as? [NSDictionary]
                guard let count = result?.count else {
                    return
                }
                for i in 0..<count {
                    let taskDict =  result![i]
                    if  let taskListModel = MsgListModel.mj_object(withKeyValues: taskDict) {
                        self?.missionListArray.append(taskListModel)
                    }
                }
                self?.contactListTableView.reloadData()
                if p == self?.pages {
                    self?.contactListTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.contactListTableView.mj_footer.endRefreshing()
                }
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
            }else{
                //服务器
                self?.contactListTableView.mj_header.endRefreshing()
                self?.contactListTableView.mj_footer.endRefreshing()
            }
            
        }
    }
}

extension QuickViewMessgaesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msgCell = tableView.dequeueReusableCell(withIdentifier: "ContactListUserCell") as! QuickMessageListTableViewCell
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentQucikViewListCell") as! CommentQucikViewListTableViewCell
        
        if missionListArray.count > 0 {
            commentCell.viewModel = missionListArray[indexPath.row]
            msgCell.viewModel = headMsgModel
        }

        if indexPath.row == 0 {
            return msgCell
        } else {
            return commentCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return 148
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if missionListArray.count > 0 && indexPath.row > 0 {
            let momentsCommentDetialVC = UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "MomentsCommentDetialViewController") as! MomentsCommentDetialViewController
            
            momentsCommentDetialVC.id = missionListArray[indexPath.row - 1].id
            self.navigationController?.pushViewController(momentsCommentDetialVC, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
//
//    //MARK: - left slide to delete row
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        //TODO: remove form data source
//        if editingStyle == .delete {
//            tempCellData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
//        }
//
//    }
//    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除"
//    }
    
    
}
