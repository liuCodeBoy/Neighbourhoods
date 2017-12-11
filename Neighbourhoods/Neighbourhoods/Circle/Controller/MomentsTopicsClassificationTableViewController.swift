
import UIKit
import MJRefresh
class MomentsTopicsClassificationTableViewController: UITableViewController {
    var     page  = 1
    var     pages : Int?
    private var progressView : UIView?
    var     isChooseTopic : NSInteger?
    private lazy var  rotaionArray = [NborTopicModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        self.tableView.showsVerticalScrollIndicator = false
        if  isChooseTopic == nil{
            lastedRequest(p : page)
        }else{
            loadPickTopic(p: page)
        }
        loadRefreshComponet()
        //    var progressView: UIView?
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.setNavBarTitle(title: "精选话题")
        self.progressView = progress
        self.tableView.addSubview(progress)
        
        // MARK:- adjust tableview height
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadRefreshComponet() -> () {
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true
    }
   
    @objc func  endrefresh() -> (){
        if  isChooseTopic == nil{
            lastedRequest(p : page)
        }else{
            loadPickTopic(p: page)
        }
        
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        NetWorkTool.shareInstance.topic_list(p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                {
                    self?.pages = (pages as! Int)
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = NborTopicModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
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
            }else{
                //服务器
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
                }
                self?.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    //MARK: - 最新发布网络请求
    func loadPickTopic(p : Int) -> () {
        NetWorkTool.shareInstance.choice_topic(p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                {
                    self?.pages = (pages as! Int)
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = NborTopicModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
                }
                self?.tableView.reloadData()
                if p == self?.pages {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.tableView.mj_footer.endRefreshing()
                }
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
            }else{
                //服务器
                self?.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let destVC = self.storyboard?.instantiateViewController(withIdentifier: "TopicDetialTableVC") as! TopicDetialTableViewController
        guard rotaionArray.count > 0  else {
            return
        }
        destVC.id = self.rotaionArray[indexPath.row].id
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rotaionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsTopicsClassificationCell")  as! MomentsTopicsClassificationTableViewCell
        if self.rotaionArray.count > 0  {
            cell.cellModel = self.rotaionArray[indexPath.row]
        }
        return cell
    }

}



