//
//  ReceivedMissionsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 03/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class ReceivedMissionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var receivedMissionTableView: UITableView!
    @IBOutlet weak var noMissionView: UIView!
    
    private var pages = 1
    private var page = 1
    
    var myMissionArray = [MyMissionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receivedMissionTableView.delegate = self
        receivedMissionTableView.dataSource = self
        
        if myMissionArray.count == 0 {
            noMissionView.isHidden = false
        } else {
            noMissionView.isHidden = true
        }
        
//        lastedRequest(p: page)
//        loadRefreshComponet()
        
    }
        
//        func loadRefreshComponet() -> () {
//            //默认下拉刷新
//            receivedMissionTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
//            //上拉刷新
//            receivedMissionTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
//            //自动根据有无数据来显示和隐藏
//            receivedMissionTableView.mj_footer.isAutomaticallyHidden = true
//            // 设置自动切换透明度(在导航栏下面自动隐藏)
//            receivedMissionTableView.mj_header.isAutomaticallyChangeAlpha = true
//        }
//        @objc func refresh() -> () {
//            receivedMissionTableView.reloadData()
//            receivedMissionTableView.mj_header.endRefreshing()
//
//        }
//        @objc func  endrefresh() -> (){
//            lastedRequest(p: page)
//
//        }
    
        //MARK: - 最新发布网络请求
//        func lastedRequest(p : Int) -> () {
//            NetWorkTool.shareInstance.myTask(HTTP_TOKEN: "273c4b5a83f1c7ef5dae664d258e5652", type: 2, p: page) { [weak self](info, error) in
//                if info?["code"] as? String == "200"{
//                    if let pages  = info!["result"]!["pages"] {
//                        self?.pages = pages as! Int
//                    }
//                    if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
//                        self?.page += 1
//                    }
//                    let result  = info!["result"]!["list"] as! [NSDictionary]
//                    for i in 0..<result.count {
//                        let taskDict =  result[i]
//                        if  let taskListModel = MyMissionModel.mj_object(withKeyValues: taskDict) {
//                            self?.myMissionArray.append(taskListModel)
//                        }
//                    }
//                    self?.receivedMissionTableView.reloadData()
//                    if p == self?.pages {
//                        self?.receivedMissionTableView.mj_footer.endRefreshingWithNoMoreData()
//                    }
//                }else{
//                    //服务器
//                    self?.receivedMissionTableView.mj_header.endRefreshing()
//                    self?.receivedMissionTableView.mj_footer.endRefreshing()
//                }
//                
//            }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMissionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReceivedMissionsCell") as! ReceivedMissionsTableViewCell
        cell.viewModel = myMissionArray[indexPath.row]
        return cell
    }

}


