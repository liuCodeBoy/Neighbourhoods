//
//  SocialAnnouncementTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

let announcementDetialNotification = "com.NJQL.announcement"

class SocialAnnouncementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var progressView: UIView?

    private var pages = 1
    private var page  = 1
    
    var noticeArray = [ActListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.tableview.addSubview(progress)
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
        
        NetWorkTool.shareInstance.announcementNotice_list(p: self.page) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let dict =  result[i]    
                    if  let model = ActListModel.mj_object(withKeyValues: dict) {
                        self?.noticeArray.append(model)
                    }
                }
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
                }
                self?.tableview.reloadData()
                if p == self?.pages {
                    self?.tableview.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.tableview.mj_footer.endRefreshing()
                }
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                }
            } else{
                //服务器
                self?.tableview.mj_header.endRefreshing()
                self?.tableview.mj_footer.endRefreshing()
                
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
                }
            }
            
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SocialAnnouncementCell")! as! SocialAnnouncementTableViewCell
        guard noticeArray.count > 0 else {
            return cell
        }
        cell.viewModel = noticeArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard noticeArray.count > 0 else {
            return
        }
        let announceVCDet = self.storyboard?.instantiateViewController(withIdentifier: "SocialAnoDetialVCID") as!
        SocialAnnouncementDetialViewController
        let model = noticeArray[indexPath.row]
        announceVCDet.url = NSURL.init(string: model.content!)
        announceVCDet.id = model.id
        self.navigationController?.pushViewController(announceVCDet, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

}
