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
    
    var progressView: UIView?
    
    var socialCharityListArray = [SocialOrgListModel]()
    
    var destnation: SocialCharityDetialViewController?
    
    private var urlString: String? {
        didSet {
            destnation?.urlString = self.urlString
        }
    }
    private var id : NSNumber?{
        didSet {
            destnation?.id  = self.id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        socialCharityListTableView.delegate = self
        socialCharityListTableView.dataSource = self
        
        setNavBarTitle(title: "社会公益组织")
        setNavBarBackBtn()
        
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
        
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
                
                // MARK:- data fetched successfully
                UIView.animate(withDuration: 0.25, animations: {
                    self?.progressView?.alpha = 0
                }, completion: { (_) in
                    self?.progressView?.removeFromSuperview()
                })
                
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
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
                }else{
                    self?.socialCharityListTableView.mj_footer.endRefreshing()
                }
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if socialCharityListArray.count > 0 {
            self.urlString = socialCharityListArray[indexPath.row].url
            self.id        = socialCharityListArray[indexPath.row].id
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialCharityListCell") as! SocialCharityListTableViewCell
        cell.viewModel = socialCharityListArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SocialCharityDetialViewController
        self.destnation = dest
    }

}
