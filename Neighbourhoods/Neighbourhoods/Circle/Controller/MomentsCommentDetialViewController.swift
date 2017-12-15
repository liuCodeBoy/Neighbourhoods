//
//  MomentsCommentDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class MomentsCommentDetialViewController: UIViewController {
    var  isTopic          : NSInteger?
    var  id               : NSNumber?
    var  topicTitle            : String?
    private var page  = 1
    private var pages : Int?
    var detailMainModel   : NborCircleModel?
    lazy var  momentsComDetListArray = [NborCircleModel]()
    private var progressView : UIView?

    @IBOutlet weak var momentsCommentDetialTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setNavBarBackBtn()
        setNavBarTitle(title: "圈内动态")
        //自动计算高度
        momentsCommentDetialTableView.estimatedRowHeight = 100
        momentsCommentDetialTableView.rowHeight = UITableViewAutomaticDimension
        
        //    var progressView: UIView?
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
   
    }
    override func viewWillAppear(_ animated: Bool) {
        //发起网络请求
        momentsComDetListArray.removeAll()
        //发起网络请求
        if isTopic == nil {
            showDetailInfo()
        }else if  isTopic == 1 {
            self.page = 1
            setNavBarTitle(title: topicTitle!)
            loadRefreshComponet()
            showTopicCom()
        }
   
    }
   
    
    func showDetailInfo() -> () {
        
        NetWorkTool.shareInstance.nbor_Detail(id: self.id as! NSInteger, uid: UserDefaults.standard.integer(forKey: "uid")) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                let result  = info!["result"] as? [String : Any]
                self?.detailMainModel = NborCircleModel.mj_object(withKeyValues: result)
                let commentListArr = result!["comment_list"] as? [[String : Any]]
                for  comment  in commentListArr! {
                    if  let model = NborCircleModel.mj_object(withKeyValues: comment){
                    self?.momentsComDetListArray.append(model)
                    }
                }
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
                }
                self?.momentsCommentDetialTableView.reloadData()
            }else{
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
                }
                //服务器
             }
           }
        }
    
    func showTopicCom() -> () {
            NetWorkTool.shareInstance.topic_com(id: self.id as! NSInteger, uid: UserDefaults.standard.integer(forKey: "uid"), p: self.page) {[weak self](info, error) in
                if info?["code"] as? String == "200"{
                    if let pages  = info!["result"]!["pages"]
                    {   if pages != nil {
                        self?.pages = (pages as! Int)
                        }
                    }
                    let result  = info!["result"] as? [String : Any]
                    self?.detailMainModel = NborCircleModel.mj_object(withKeyValues: result)
                    let commentListArr = result!["comment_list"] as? [[String : Any]]
                    for  comment  in commentListArr! {
                        if  let model = NborCircleModel.mj_object(withKeyValues: comment){
                            self?.momentsComDetListArray.append(model)
                        }
                    }
                    if self?.progressView != nil {
                        self?.progressView?.removeFromSuperview()
                    }
                    self?.momentsCommentDetialTableView.reloadData()
                    if self?.page == self?.pages {
                        self?.momentsCommentDetialTableView.mj_footer.endRefreshingWithNoMoreData()
                    }else{
                        self?.momentsCommentDetialTableView.mj_footer.endRefreshing()
                    }
                    if let tempPage = self?.page, let tempPages = self?.pages {
                        if tempPage < tempPages {
                            self?.page += 1
                        }
                    }
                }else{
                    if self?.progressView != nil {
                        self?.progressView?.removeFromSuperview()
                    }
                    //服务器
                    self?.momentsCommentDetialTableView.mj_header.endRefreshing()
                    self?.momentsCommentDetialTableView.mj_footer.endRefreshing()
                }
            }
        }
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        momentsCommentDetialTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        momentsCommentDetialTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        momentsCommentDetialTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        momentsCommentDetialTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        self.page = 1
        self.momentsComDetListArray.removeAll()
        showTopicCom()
        momentsCommentDetialTableView.mj_header.endRefreshing()
    }
    @objc func  endrefresh() -> (){
        showTopicCom()
    }
    
    
     }

extension MomentsCommentDetialViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.momentsComDetListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsCommentDetialHeaderCell") as! MomentsCommentDetialHeaderTableViewCell
            if self.isTopic != nil {
            cell.isTopic = self.isTopic
            }
            if detailMainModel != nil {
            cell.momentsCellModel = detailMainModel
            }
            //跳出用户详情
            cell.headImagePushClouse = { (otherID) in
                let userInfoVc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "OthersMomentsID") as? OthersMomentsViewController
                userInfoVc?.uid = otherID as? Int
                if  UserDefaults.standard.string(forKey: "token") == nil{
                    self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
                }else{
                    self.navigationController?.pushViewController(userInfoVc!, animated: true)
                }
            }
            //跳出评论
            cell.showCommentClouse = {[weak self](pid ,to_uid ,uid,post_id) in
                let commentVc = self?.storyboard?.instantiateViewController(withIdentifier: "WriteCommentIdent") as? WriteCommentViewController
                if self?.isTopic != nil{
                    commentVc?.isTopic = self?.isTopic
                }
                commentVc?.pid =  0
                commentVc?.to_uid  = self?.detailMainModel?.uid
                commentVc?.uid     = self?.detailMainModel?.uid
                commentVc?.post_id = self?.detailMainModel?.id
                self?.navigationController?.pushViewController(commentVc!, animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsCommentDetialSpecificCommentCell") as? MomentsCommentDetialSpecificCommentTableViewCell
            if self.isTopic != nil{
                cell?.isTopic = self.isTopic
            }
            cell?.pushClouse = {(id) in
                let desVC = UIStoryboard(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "SecondaryCommentTable") as!  SecondaryCommentTableViewController
                desVC.id = id
                if self.isTopic != nil{
                desVC.isTopic = self.isTopic
                }
                self.navigationController?.pushViewController(desVC, animated: true)
            }
            guard momentsComDetListArray.count > 0 else{
                return cell!
            }
            let  model = self.momentsComDetListArray[indexPath.row]
            cell?.momentsCellModel = model
            //跳出用户详情
            cell?.headImagePushClouse = { (otherID) in
                let userInfoVc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "OthersMomentsID") as? OthersMomentsViewController
                userInfoVc?.uid = otherID as? Int
                if  UserDefaults.standard.string(forKey: "token") == nil{
                    self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
                }else{
                    self.navigationController?.pushViewController(userInfoVc!, animated: true)
                }
            }
            //跳出评论
            cell?.showCommentClouse = {[weak self](pid ,to_uid ,uid,post_id) in
                let commentVc = self?.storyboard?.instantiateViewController(withIdentifier: "WriteCommentIdent") as? WriteCommentViewController
                if self?.isTopic != nil{
                    commentVc?.isTopic = self?.isTopic
                }
                commentVc?.pid     =  model.id
                commentVc?.to_uid  =  model.uid
                commentVc?.uid     =  self?.detailMainModel?.uid
                commentVc?.post_id =  self?.detailMainModel?.id
                self?.navigationController?.pushViewController(commentVc!, animated: true)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12
        } else {
            return 0.00001
        }
    }
    
}
