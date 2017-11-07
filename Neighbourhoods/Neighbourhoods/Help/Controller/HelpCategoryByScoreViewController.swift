//
//  HelpCategoryByScoreTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 03/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class HelpCategoryByScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    private var pages = 1
    private var page  = 1
    
    var taskListArray = [TaskListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        lastedRequest(p: page)
        loadRefreshComponet()
        
    }
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        tableview.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        tableview.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableview.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableview.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        tableview.reloadData()
        tableview.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        
        NetWorkTool.shareInstance.taskList(sort: "task_status", p: 1) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
                }
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let taskDict =  result[i]
                    if  let taskListModel = TaskListModel.mj_object(withKeyValues: taskDict) {
                        self?.taskListArray.append(taskListModel)
                    }
                }
                self?.tableview.reloadData()
                if p == self?.pages {
                    self?.tableview.mj_footer.endRefreshingWithNoMoreData()
                }
            }else{
                //服务器
                self?.tableview.mj_header.endRefreshing()
                self?.tableview.mj_footer.endRefreshing()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCategoryByScoreCell") as! HelpCategoryByScoreTableViewCell
        cell.viewModel = taskListArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
