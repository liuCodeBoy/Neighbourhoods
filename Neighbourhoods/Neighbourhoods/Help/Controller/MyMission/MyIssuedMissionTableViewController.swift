//
//  MyIssuedMissionTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 13/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class MyIssuedMissionTableViewController: UITableViewController {
    
    private var pages = 1
    private var page = 1
    
    var progressView: UIView?

    lazy var coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    
    var missionID: Int? {
        didSet {
            destnationVC?.missionID = self.missionID!
        }
    }
    
    var destnationVC: MissionDetialViewController?
    
    var myMissionArray = [TaskListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastedRequest(p: page)
        loadRefreshComponet()
        
        setNavBarTitle(title: "我发布的任务")
        setNavBarBackBtn()
        
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 90)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
        
        // MARK:- table view row height
        self.tableView.estimatedRowHeight = 180
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
        self.page = 1
        self.myMissionArray.removeAll()
        lastedRequest(p: page)
        tableView.mj_header.endRefreshing()
        
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
        
        NetWorkTool.shareInstance.myTask(access_token, type: 1, p: page, finished: { [weak self](info, error) in
            
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
                }
                
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let taskDict =  result[i]
                    if  let taskListModel = TaskListModel.mj_object(withKeyValues: taskDict) {
                        self?.myMissionArray.append(taskListModel)
                    }
                }
                self?.tableView.reloadData()
                if p == self?.pages {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.tableView.mj_footer.endRefreshing()
                }
                // FIXME:- under some circumsatances it will brake for upwrapping nil
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
                
                guard let arrayCount = self?.myMissionArray.count else {
                    return
                }
            } else if info?["code"] as? String  == "402" {
                self?.coverView.showLab.text = "暂无任务"
                self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self?.view.addSubview((self?.coverView)!)
            }else{
                //服务器
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMissionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssuedMissionCell") as! MyIssuedMissionTableViewCell
        if myMissionArray.count > 0 {
            cell.viewModel = myMissionArray[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK:- restore the id
        if myMissionArray.count > 0 {
            missionID = myMissionArray[indexPath.row].id as? Int
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! MissionDetialViewController
        destnationVC = dest
        
    }


}
