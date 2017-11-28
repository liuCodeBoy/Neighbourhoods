//
//  MyScoreVC.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class MyScoreViewController: UIViewController {
    
    @IBOutlet weak var receiveScoreTableView: UITableView!
    
    @IBOutlet weak var allScoreLbl: UILabel!
    
    var progressView: UIView?

    var score: String?
    
    private var pages = 1
    private var page  = 1
    
    let coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    
    var myScoreArray = [MyIntegralModel]()
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receiveScoreTableView.delegate = self
        receiveScoreTableView.dataSource = self
        
        allScoreLbl.text = score
        
        lastedRequest(p: page)
        loadRefreshComponet()
        
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
    }
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        receiveScoreTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        receiveScoreTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        receiveScoreTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        receiveScoreTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        self.page = 1
        self.myScoreArray.removeAll()
        lastedRequest(p: page)
        receiveScoreTableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        
        NetWorkTool.shareInstance.myScore(access_token, p: page) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                
                // MARK:- data fetched successfully
                UIView.animate(withDuration: 0.25, animations: {
                    self?.progressView?.alpha = 0
                }, completion: { (_) in
                    self?.progressView?.removeFromSuperview()
                })
                
                guard let pages  = info?["result"]?["pages"] as? Int else {
//                    self?.coverView.showLab.text = "暂无积分"
//                    self?.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//                    self?.receiveScoreTableView.addSubview((self?.coverView)!)
//                    self?.receiveScoreTableView.isScrollEnabled = false
                    return
                }
                self?.pages = pages
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let taskDict =  result[i]
                    if  let taskListModel = MyIntegralModel.mj_object(withKeyValues: taskDict) {
                        self?.myScoreArray.append(taskListModel)
                    }
                }
                self?.receiveScoreTableView.reloadData()
                if p == self?.pages {
                    self?.receiveScoreTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.receiveScoreTableView.mj_footer.endRefreshing()
                }
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
                if CGFloat((self?.myScoreArray.count)!) > 0 {
                    self?.coverView.removeFromSuperview()
                }
            }else{
                //服务器
                self?.receiveScoreTableView.mj_header.endRefreshing()
                self?.receiveScoreTableView.mj_footer.endRefreshing()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }

}

extension MyScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveScoreCell") as! ReceivedScoreListTableViewCell
        if myScoreArray.count > 0 {
            cell.viewModel = myScoreArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myScoreArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
