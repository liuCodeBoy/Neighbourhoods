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
    
    
    var detialVC: MissionDetialViewController?
    
    private var idNum: Int? {
        didSet {
            detialVC?.id = self.idNum
        }
    }
    
    var myMissionArray = [MyMissionModel]()

    @IBOutlet weak var noMissionCoverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastedRequest(p: page)
        loadRefreshComponet()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if myMissionArray.count == 0 {
            let nomission = Bundle.main.loadNibNamed("NoMissionCoverView", owner: self, options: nil)?.first as! UIView
            nomission.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            self.view.addSubview(nomission)
            self.tableView.isScrollEnabled = false
        }
    }
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        self.tableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        self.tableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        self.tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        self.tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        let token = UserDefaults.standard.object(forKey: "token") as! String
        NetWorkTool.shareInstance.myTask(token, type: 1, p: page) { [weak self](info, error) in
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
        return myMissionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssuedMissionCell") as! MyIssuedMissionTableViewCell
        cell.viewModel = myMissionArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idNum = myMissionArray[indexPath.row].id as? Int
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! MissionDetialViewController
        self.detialVC = dest

    }
    


}
