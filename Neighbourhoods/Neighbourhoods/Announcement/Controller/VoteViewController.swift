//
//  ActivityVoteTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class VoteViewController: UIViewController{
    var page  = 1
    var pages : Int?
    var  progressView: UIView?
    lazy var  rotaionArray = [VoteListModel]()
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate   = self
        tableview.dataSource = self
        //添加进度
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.tableview.addSubview(progress)
        self.progressView = progress
        
        loadRefreshComponet()
        refresh()
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
        self.page = 1
        self.rotaionArray.removeAll()
        lastedRequest(p: page)
        tableview.mj_header.endRefreshing()
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        NetWorkTool.shareInstance.act_list(p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                {
                    self?.pages = (pages as! Int)
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = VoteListModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
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
            }else{
                //服务器
                self?.tableview.mj_header.endRefreshing()
                self?.tableview.mj_footer.endRefreshing()
            }
            
        }
    }
    
  
    

}



extension VoteViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rotaionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityVoteCell") as! ActivityVoteTableViewCell
        let figureCell = tableView.dequeueReusableCell(withIdentifier: "FigureVoteCell") as! FigureVoteTableViewCell
        
        guard self.rotaionArray.count > 0 else {
            return  activityCell
        }
        //取出模型 ：2正在投票；1协商中；-1已结束
        let model = self.rotaionArray[indexPath.row]
        let cate = model.cate as! Int
        if cate == 1 {
            figureCell.modle = model
            return figureCell
        }else{
            activityCell.modle = model
            return activityCell
        }
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.rotaionArray.count > 0 else {
            return
        }
        //取出模型 ：2正在投票；1协商中；-1已结束
        let model = self.rotaionArray[indexPath.row]
  //      let cate = model.cate as! Int
//        if cate == 1 {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FigureVoteListVC") as! FigureVoteListViewController
//            vc.id = model.id
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
            if model.status == -1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityVoteEndedVC") as! ActivityVoteEndedViewController
                vc.id = model.id
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if  model.status == 1{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityVoteConsultingVC") as! ActivityVoteConsultingViewController
                vc.id = model.id
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.status == 2{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityVoteCounsultantCompletedVC") as! ActivityVoteCounsultantCompletedViewController
                vc.id = model.id
                vc.status = model.status
                vc.cate = model.cate
                self.navigationController?.pushViewController(vc, animated: true)
            }
//        }

    }
}
