//
//  SocialCharityViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class SocialCharityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var socialCharityListTableView: UITableView!
    
    private var pages = 1
    private var page  = 1
    
    var socialCharityListArray = [SocialOrgListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        socialCharityListTableView.delegate = self
        socialCharityListTableView.dataSource = self
        
        setNavBarTitle(title: "社会公益组织")
        setNavBarBackBtn()
        
        lastedRequest(p: page)
        loadRefreshComponet()
        
    }
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        socialCharityListTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        socialCharityListTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        socialCharityListTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        socialCharityListTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        socialCharityListTableView.reloadData()
        socialCharityListTableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        
        NetWorkTool.shareInstance.socialCharityList(p: 1) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
                }
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let dict =  result[i]
                    if  let model = SocialOrgListModel.mj_object(withKeyValues: dict) {
                        self?.socialCharityListArray.append(model)
                    }
                }
                self?.socialCharityListTableView.reloadData()
                if p == self?.pages {
                    self?.socialCharityListTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }else{
                //服务器
                self?.socialCharityListTableView.mj_header.endRefreshing()
                self?.socialCharityListTableView.mj_footer.endRefreshing()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialCharityListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialCharityListCell") as! SocialCharityListTableViewCell
        cell.viewModel = socialCharityListArray[indexPath.row]
        return cell
    }

}
