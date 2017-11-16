//
//  SecondaryCommentTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class SecondaryCommentTableViewController: UITableViewController {
     var  id  : NSNumber?
    private  var  page  = 1
    private  var  pages : Int?
    private  var  detailModelArr = [NborCircleModel]()
    private  var  mainCommentModel : NborCircleModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRefreshComponet()
        lastedRequest(p: page)
    }
    
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        tableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        tableView.reloadData()
        tableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        NetWorkTool.shareInstance.nbor_com_det(id: self.id as! NSInteger, p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                {
                    if pages != nil {
                        self?.pages = pages as? Int
                    }
                }
                let result  = info!["result"] as! [String : Any]
                self?.mainCommentModel =  NborCircleModel.mj_object(withKeyValues: result)
                let resultComment = result["sec_comment"] as? [[String : Any]]
                for dict  in  resultComment!
                {
                    if  let rotationModel = NborCircleModel.mj_object(withKeyValues: dict)
                    {
                        self?.detailModelArr.append(rotationModel)
                    }
                }
                self?.tableView.reloadData()
                if p == self?.pages {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.tableView.mj_footer.endRefreshing()
                }
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                }
                
            }else{
                //服务器
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailModelArr.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondaryCommentHeaderCell") as! SecondaryCommentHeaderTableViewCell
            if mainCommentModel != nil {
            cell.momentsCellModel =  mainCommentModel
            }
            //跳出用户详情
            cell.headImagePushClouse = { (otherID) in
                let userInfoVc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "OthersMomentsID") as? OthersMomentsViewController
                userInfoVc?.uid = otherID as? Int
                if  UserDefaults.standard.string(forKey: "token") == nil{
                    self.presentHintMessage(target: self, hintMessgae:  "你还未登录")
                }else{
                    self.navigationController?.pushViewController(userInfoVc!, animated: true)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondaryCommentDetialCell")  as! SecondaryCommentDetialTableViewCell
            if  self.detailModelArr[indexPath.row - 1] != nil{
            cell.momentsCellModel = detailModelArr[indexPath.row - 1]
            }
            //跳出用户详情
            cell.headImagePushClouse = { (otherID) in
                let userInfoVc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "OthersMomentsID") as? OthersMomentsViewController
                userInfoVc?.uid = otherID as? Int
                if  UserDefaults.standard.string(forKey: "token") == nil{
                    self.presentHintMessage(target: self, hintMessgae:  "你还未登录")
                }else{
                    self.navigationController?.pushViewController(userInfoVc!, animated: true)
                }
            }
            return cell
        }
    }
}




