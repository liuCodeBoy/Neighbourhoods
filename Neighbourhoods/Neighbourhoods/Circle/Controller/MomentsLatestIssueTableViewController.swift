//
//  MomentsLatestIssueTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class MomentsLatestIssueTableViewController: UITableViewController {
    var page  = 1
    var pages : Int?
    lazy var  rotaionArray = [NborCircleModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        loadRefreshComponet()
        lastedRequest(p : page)
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
    
            NetWorkTool.shareInstance.nbor_list(Nbor_Sort.time, p: p) {[weak self](info, error) in
                if info?["code"] as? String == "200"{
                    if let pages  = info!["result"]!["pages"]
                     {
                        self?.pages = pages as! Int
                     }
                    if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                        self?.page += 1
                    }
                    let result  = info!["result"]!["list"] as! [NSDictionary]
                    for i in 0..<result.count
                    {
                        let  circleInfo  =  result[i]
                        if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
                        {
                            self?.rotaionArray.append(rotationModel)
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
        // #warning Incomplete implementation, return the number of rows
        return self.rotaionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsLatestIssueCell") as! MomentsLatestIssueTableViewCell
        let modelArr =  self.rotaionArray
        let  model =  modelArr[indexPath.row]
        cell.momentsCellModel = model
        return cell
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let   momentsCommentDetialVC =  UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "MomentsCommentDetialViewController") as! MomentsCommentDetialViewController
        let modelArr =  self.rotaionArray
        let  model =  modelArr[indexPath.row]
         momentsCommentDetialVC.id = model.id
        self.navigationController?.pushViewController(momentsCommentDetialVC, animated: true)
    }


}


//  //MARK: - 初始化刷新
//
//
//    @objc func  endrefresh() -> (){
//        if isLasted {
//        lastedRequest(p: lastPageEnd,isTop : false)
//        }else{
//       lastedTopicRequest(p: likePageEnd, isTop: false)
//        }
//}
//
//  //MARK: - 最新发布网络请求
//    func lastedRequest(p : Int , isTop : Bool) -> () {
//
//        NetWorkTool.shareInstance.nbor_list(Nbor_Sort.time, p: p) {[weak self](info, error) in
//            if info?["code"] as? String == "200"{
//                if let pages  = info!["result"]!["pages"]
//                 {
//                    self?.lastedAllPages = pages as! Int
//                 }
//                if  CGFloat((self?.lastPageEnd)!) <  CGFloat((self?.lastedAllPages)!){
//                    self?.lastPageEnd += 1
//                }
//                let result  = info!["result"]!["list"] as! [NSDictionary]
//                for i in 0..<result.count
//                {
//                    let  circleInfo  =  result[i]
//                    if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
//                    {
//                        if isTop == false
//                        {
//                        self?.rotaionArray.append(rotationModel)
//                        }else{
//                        self?.rotaionArray.insert(rotationModel, at: 0)
//                        }
//                    }
//                }
//                self?.momentsTopicsTableView.reloadData()
//                if p == self?.lastedAllPages {
//                    self?.momentsTopicsTableView.mj_footer.endRefreshingWithNoMoreData()
//                }
//            }else{
//                //服务器
//                self?.momentsTopicsTableView.mj_header.endRefreshing()
//                self?.momentsTopicsTableView.mj_footer.endRefreshing()
//                 }
//
//        }
//    }
//   //MARK: - 最新话题网络请求
//    func lastedTopicRequest(p : Int,isTop : Bool) -> (){
//        NetWorkTool.shareInstance.nbor_list(Nbor_Sort.like, p: p) {[weak self](info, error) in
//                if info?["code"] as? String == "200"{
//
//                    if let pages  = info!["result"]!["pages"]
//                    {
//                        self?.likedAllPages = pages as! Int
//                    }
//                    if  CGFloat((self?.likePageEnd)!) <  CGFloat((self?.likedAllPages)!){
//                        self?.likePageEnd += 1
//                    }
//
//                    let result  = info!["result"]!["list"] as! [NSDictionary]
//
//                    for i in 0..<result.count
//                    {
//                        let  circleInfo  =  result[i]
//                        if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
//                        {
//                            if isTop == false
//                            {
//                                self?.hotArray.append(rotationModel)
//                            }else{
//                                self?.hotArray.insert(rotationModel, at: 0)
//                            }
//                        }
//                    }
//                    self?.momentsTopicsTableView.reloadData()
//                    if p == self?.likedAllPages {
//                        self?.momentsTopicsTableView.mj_footer.endRefreshingWithNoMoreData()
//                    }
//                }else{
//                    //服务器
//                    self?.momentsTopicsTableView.mj_header.endRefreshing()
//                    self?.momentsTopicsTableView.mj_footer.endRefreshing()
//                }
//        }
//    }



