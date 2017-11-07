//
//  MyMissionsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

enum MissionStatus: String {
    case `default` = "未领取"
    case process = "已领取"
    case done = "已完成"
}

class MyMissionsViewController: UIViewController {
    
    @IBOutlet weak var myIssueMissionBtn: UIButton!
    @IBOutlet weak var receivedMissionBtn: UIButton!
    
    var childView: UIView?
    
    var myMissionArray = [MyMissionModel]()
    
    private var pages = 1
    private var page = 1
    
    @IBOutlet weak var lineView: UIView!
    @IBAction func btn1Clicked(_ sender: UIButton) {
        myIssueMissionBtn.isSelected    = true
        receivedMissionBtn.isSelected   = false
        
        missionsTableView.isHidden      = false
        childView?.isHidden             = true
    }
    @IBAction func btn2Clicked(_ sender: UIButton) {
        myIssueMissionBtn.isSelected    = false
        receivedMissionBtn.isSelected   = true
        
        missionsTableView.isHidden      = true
        childView?.isHidden             = false
    }
    
    @IBOutlet weak var missionsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarBackBtn()
        self.setNavBarTitle(title: "我的任务")
        missionsTableView.delegate = self
        missionsTableView.dataSource = self
        
        loadTableViews()
        childView?.isHidden = true
        
        lastedRequest(p: page)
        loadRefreshComponet()

    }
    
    func loadTableViews() {

        let childVC = self.storyboard?.instantiateViewController(withIdentifier: "ReceivedMissionsVC") as! ReceivedMissionsViewController
        childView = childVC.view
        let y = lineView.frame.origin.y + 1
        childView?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)

        self.addChildViewController(childVC)
        self.view.addSubview(childView!)
    }
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        missionsTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        missionsTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        missionsTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        missionsTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        missionsTableView.reloadData()
        missionsTableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        NetWorkTool.shareInstance.myTask(HTTP_TOKEN: "273c4b5a83f1c7ef5dae664d258e5652", type: 1, p: page) { [weak self](info, error) in
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
                    if  let taskListModel = MyMissionModel.mj_object(withKeyValues: taskDict) {
                        self?.myMissionArray.append(taskListModel)
                    }
                }
                self?.missionsTableView.reloadData()
                if p == self?.pages {
                    self?.missionsTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }else{
                //服务器
                self?.missionsTableView.mj_header.endRefreshing()
                self?.missionsTableView.mj_footer.endRefreshing()
            }
            
        }
    }

}


extension MyMissionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMissionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssuedMissionsCell")  as! MyMissionsTableViewCell
        cell.viewModel = myMissionArray[indexPath.row]
        return cell
    }
}
