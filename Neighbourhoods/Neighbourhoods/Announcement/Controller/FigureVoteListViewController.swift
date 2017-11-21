//
//  FigureVoteListViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class FigureVoteListViewController: UIViewController {
    var  id : NSNumber?
    var page  = 1
    var pages : Int?
    lazy var  rotaionArray = [VoteOptionList]()
    @IBOutlet weak var figureVoteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        figureVoteTableView.delegate = self
        figureVoteTableView.dataSource = self
    
        setNavBarBackBtn()
        setNavBarTitle(title: "正在投票")
      
    }
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        figureVoteTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        figureVoteTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        figureVoteTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        figureVoteTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        self.page = 1
        self.rotaionArray.removeAll()
//        lastedRequest( p: <#T##Int#>, status: <#T##Int#>, cate: <#T##Int#>, id: <#T##Int#>)
        figureVoteTableView.mj_header.endRefreshing()
    }
    @objc func  endrefresh() -> (){
//        lastedRequest
    }
    func lastedRequest(p: Int, status: Int, cate: Int, id: Int) -> () {
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
         self.presentHintMessage(target: self, hintMessgae: "您还未登录")
           return
         }
        NetWorkTool.shareInstance.option_list("1", p: 2, status: 1, cate: 2, id: 1) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                                if let pages  = info!["result"]!["pages"]
                                {
                                    self?.pages = (pages as! Int)
                                }
                                let result  = info!["result"] as! [NSDictionary]
                                for i in 0..<result.count
                                {
                                    let  circleInfo  =  result[i]
                                    if  let rotationModel = VoteOptionList.mj_object(withKeyValues: circleInfo)
                                    {
                                        self?.rotaionArray.append(rotationModel)
                                    }
                                }
                                self?.figureVoteTableView.reloadData()
                                if p == self?.pages {
                                    self?.figureVoteTableView.mj_footer.endRefreshingWithNoMoreData()
                                }else{
                                    self?.figureVoteTableView.mj_footer.endRefreshing()
                                }
                                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                                    self?.page += 1
                                }
                            }else{
                                //服务器
                                self?.figureVoteTableView.mj_header.endRefreshing()
                                self?.figureVoteTableView.mj_footer.endRefreshing()
                    }
            }
        
     }
}

extension FigureVoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FigureVoteCell")!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
