   //
//  TopicDetialTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import  UIKit
import  MJRefresh
import  SDWebImage
class TopicDetialTableViewController: UITableViewController {
    var  id  : NSNumber?
    private var  rotaionArray = [NborCircleModel]()
    private var  modelMain : NborTopicModel?
    private  var  page  = 1
    private  var  pages : Int?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var topicDetialTextView: UITextView!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var readCountLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRefreshComponet()
        lastedRequest(p: page)
        self.tableView.reloadData()
        setNavBarBackBtn()
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
    
    @objc  private func refresh() -> () {
        self.page = 1
        self.rotaionArray.removeAll()
        lastedRequest(p: page)
        tableView.mj_header.endRefreshing()
        
    }
    @objc private func  endrefresh() -> (){
        lastedRequest(p : self.page)
        
    }
    @IBAction func showCommentVC(_ sender: Any) {
        let commentVc = UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "TopicCommentVCID") as? TopicCommentVC
        commentVc?.pid = 0
        commentVc?.to_uid  = modelMain?.uid
        commentVc?.uid     = modelMain?.uid
        commentVc?.post_id = modelMain?.id
        self.navigationController?.pushViewController(commentVc!, animated: true)
    }
    
    
    //MARK: - 最新发布网络请求
   private func lastedRequest(p : Int) -> () {
    NetWorkTool.shareInstance.topic_det(id : self.id as! NSInteger, p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let tempPages  = info!["result"]!["pages"]
                {
                    if tempPages != nil{
                        self?.pages = (tempPages as! Int)
                    }
                }
                let resultMain = info!["result"]
                self?.modelMain =  NborTopicModel.mj_object(withKeyValues: resultMain)
                if self?.modelMain != nil {
                    if let avatarString  =  self?.modelMain?.picture {
                        self?.topicImage.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                    }
                    self?.topicDetialTextView.text = self?.modelMain?.content
                    if let title = self?.modelMain?.name {
                        self?.setNavBarTitle(title: "#"+title+"#")
                    }
                    if let comment = self?.modelMain?.comment {
                        self?.commentCountLbl.text = "\(String(describing: comment))条评论"
                    }
                    if let browse_history = self?.modelMain?.browse_history {
                        self?.readCountLbl.text  = "\(String(describing: browse_history))阅读"
                    }
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let model =  NborCircleModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(model)
                    }
                }
                self?.tableView.reloadData()
                if self?.page == self?.pages {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.tableView.mj_footer.endRefreshing()
                }
                if self?.pages != nil {
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                  }
                }
                
            }else{
                //服务器
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData()
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rotaionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicDetialCell") as? TopicDetialTableViewCell
        if  self.rotaionArray.count > 0 {
            cell?.title = "#"+(self.modelMain?.name)!+"#"
            cell?.TopicDetialModel = self.rotaionArray[indexPath.row]
        }
        cell?.pushImageClouse = {(imageArr, index) in
            let desVC = UIStoryboard(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "ImageShowVCID") as!  ImageShowVC
            desVC.index  = index
            desVC.imageArr = imageArr
            self.present(desVC, animated: true, completion: nil)
        }
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
        return cell!
    }


}
