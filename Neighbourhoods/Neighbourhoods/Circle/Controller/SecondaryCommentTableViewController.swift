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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRefreshComponet()
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
                    self?.pages = pages as! Int
                }
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                }
                let result  = info!["result"] as! [String : Any]
                let  mainCommentModel =  NborCircleModel.mj_object(withKeyValues: result)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsLatestIssueCell") as! MomentsLatestIssueTableViewCell
        let modelArr =  self.detailModelArr
        let  model =  modelArr[indexPath.row]
        cell.momentsCellModel = model
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let   momentsCommentDetialVC =  UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "MomentsCommentDetialViewController") as! MomentsCommentDetialViewController
        let modelArr =  self.detailModelArr
        let  model =  modelArr[indexPath.row]
        momentsCommentDetialVC.id = model.id
        self.navigationController?.pushViewController(momentsCommentDetialVC, animated: true)
    }

    //发布网络请求
    
    
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if indexPath.row == 0 {
//            return tableView.dequeueReusableCell(withIdentifier: "SecondaryCommentHeaderCell")!
//        } else {
//            return tableView.dequeueReusableCell(withIdentifier: "SecondaryCommentDetialCell")!
//        }
//    }

}




