//
//  MomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
class MomentsViewController: UIViewController {
    
    @IBOutlet weak var latestIssue: UIButton!
    @IBOutlet weak var hotestTopic: UIButton!
    @IBOutlet weak var topicClassify: UIButton!
    
    private   var     lastPageStart  = 1
    private   var     lastPageEnd    = 1
    private   var     likePageStart  = 1
    private   var     likePageEnd    = 1
    private   var     lastedAllPages = 1
    private   var     likedAllPages  = 1
    private   var     isLasted       = true
    @IBAction func btn1clicked(_ sender: UIButton) {
        latestIssue.isSelected   = true
        hotestTopic.isSelected   = false
        topicClassify.isSelected = false
        isLasted                 = true
        momentsTopicsTableView.reloadData()
    }
    @IBAction func btn2clicked(_ sender: UIButton) {
        latestIssue.isSelected    = false
        hotestTopic.isSelected    = true
        topicClassify.isSelected  = false
        isLasted                  = false
        momentsTopicsTableView.reloadData()
    }
    @IBAction func btn3clicked(_ sender: UIButton) {
        latestIssue.isSelected   = false
        hotestTopic.isSelected   = false
        topicClassify.isSelected = true
    }
    
    @IBOutlet weak var momentsTopicsTableView: UITableView!
    lazy var  rotaionArray = [NborCircleModel]()
    lazy var  hotArray     = [NborCircleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        momentsTopicsTableView.delegate = self
        momentsTopicsTableView.dataSource = self
        momentsTopicsTableView.showsVerticalScrollIndicator = false
        momentsTopicsTableView.showsHorizontalScrollIndicator = false
        loadRefreshComponet()
        lastedRequest(p: lastPageStart, isTop: false)
        lastedTopicRequest(p: likePageStart, isTop: false)
        
        setNavBarBackBtn()
        setNavBarTitle(title: "圈内动态")
        //自动计算高度
        momentsTopicsTableView.estimatedRowHeight = 100
        momentsTopicsTableView.rowHeight = UITableViewAutomaticDimension
        
    }
  //MARK: - 初始化刷新
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        momentsTopicsTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        momentsTopicsTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        momentsTopicsTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        momentsTopicsTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        if isLasted{
        self.lastedRequest(p: lastPageStart, isTop : true)
        if lastPageStart > 1 { 
          lastPageStart -= 1
        }else{
            momentsTopicsTableView.mj_header.endRefreshing()
         }
        }else{
            lastedTopicRequest(p: likePageStart, isTop: true)
            if likePageStart > 1 {
                likePageStart -= 1
            }else{
                momentsTopicsTableView.mj_header.endRefreshing()
            }
        }
    }
    
    @objc func  endrefresh() -> (){
        if isLasted {
        lastedRequest(p: lastPageEnd,isTop : false)
            if  lastPageEnd < lastedAllPages{
            lastPageEnd += 1
            }
        }else{
       lastedTopicRequest(p: likePageEnd, isTop: false)
            if  likePageEnd < likedAllPages{
            likePageEnd += 1
            }
        }
}
    
  //MARK: - 最新发布网络请求
    func lastedRequest(p : Int , isTop : Bool) -> () {
       
        NetWorkTool.shareInstance.nbor_list(Nbor_Sort.time, p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                 {
                    self?.lastedAllPages = pages as! Int
                 }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
                    {
                        if isTop == false
                        {
                        self?.rotaionArray.append(rotationModel)
                        }else{
                        self?.rotaionArray.insert(rotationModel, at: 0)
                        }
                    }
                }
                self?.momentsTopicsTableView.reloadData()
                if p == self?.lastedAllPages {
                    self?.momentsTopicsTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }else{
                //服务器
                self?.momentsTopicsTableView.mj_header.endRefreshing()
                self?.momentsTopicsTableView.mj_footer.endRefreshing()
                 }
             
        }
    }
   //MARK: - 最新话题网络请求
    func lastedTopicRequest(p : Int,isTop : Bool) -> (){
        NetWorkTool.shareInstance.nbor_list(Nbor_Sort.like, p: p) {[weak self](info, error) in
                if info?["code"] as? String == "200"{
                    if let pages  = info!["result"]!["pages"]
                    {
                        self?.likedAllPages = pages as! Int
                    }
                    let result  = info!["result"]!["list"] as! [NSDictionary]
                    for i in 0..<result.count
                    {
                        let  circleInfo  =  result[i]
                        if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
                        {
                            if isTop == false
                            {
                                self?.hotArray.append(rotationModel)
                            }else{
                                self?.hotArray.insert(rotationModel, at: 0)
                            }
                        }
                    }
                    self?.momentsTopicsTableView.reloadData()
                    if p == self?.likedAllPages {
                        self?.momentsTopicsTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }else{
                    //服务器
                    self?.momentsTopicsTableView.mj_header.endRefreshing()
                    self?.momentsTopicsTableView.mj_footer.endRefreshing()
                }
        }
    }

   

}


extension MomentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.isLasted == true ? self.rotaionArray.count : self.hotArray.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelArr = self.isLasted == true ? self.rotaionArray : self.hotArray
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsTopicCell") as!  MomentsVCLatestIssueTableViewCell
        let  model =  modelArr[indexPath.row]
        cell.momentsCellModel = model
        return cell
    }
}
