//
//  CircleMomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class CircleMomentsViewController: UIViewController {
    
    var page  = 1
    var pages : Int? = 1
    
    lazy var momentsArray = [MyCircleMomentsModel]()
    
    lazy var coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    
    @IBOutlet weak var circleMomentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleMomentsTableView.estimatedRowHeight = 100
        circleMomentsTableView.rowHeight = UITableViewAutomaticDimension
        

        circleMomentsTableView.delegate = self
        circleMomentsTableView.dataSource = self

        setNavBarTitle(title: "圈动态")
        setNavBarBackBtn()
        
        loadRefreshComponet()
        lastedRequest(p : page)
    
    }
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        circleMomentsTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        circleMomentsTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        circleMomentsTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        circleMomentsTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        self.page = 1
        self.momentsArray.removeAll()
        lastedRequest(p: page)
        circleMomentsTableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.myCircleMoments(access_token, p: page) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                {
                    self?.pages = (pages as! Int)
                }
                
                let result  = info!["result"]!["nbor_list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = MyCircleMomentsModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.momentsArray.append(rotationModel)
                    }
                }
                self?.circleMomentsTableView.reloadData()
                if p == self?.pages {
                    self?.circleMomentsTableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self?.circleMomentsTableView.mj_footer.endRefreshing()
                }
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
                
                guard let arrayCount = self?.momentsArray.count else {
                    return
                }
                if arrayCount == 0 {
                    self?.coverView.showLab.text = "暂无动态"
                    self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    self?.view.addSubview((self?.coverView)!)
                }
            }else{
                //服务器
                self?.circleMomentsTableView.mj_header.endRefreshing()
                self?.circleMomentsTableView.mj_footer.endRefreshing()
            }
            
        }
    }

}

extension CircleMomentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return momentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CircleMomentsCell") as! CircleMomentsTableViewCell
        guard self.momentsArray.count > 0 else {
            return cell
        }
        cell.viewModel = momentsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //MARK: - left slide to delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: remove form data source
        if editingStyle == .delete {
            

            // MARK:- post request to server
            
            guard let access_token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
            guard let id = momentsArray[indexPath.row].id as? Int else {
                return
            }
            NetWorkTool.shareInstance.deleteMyMoments(access_token, id: id, finished: { [weak self](result, error) in
                if error != nil {
                    print(error as AnyObject)
                } else if result!["code"] as! String == "200" {
                    self?.presentHintMessage(hintMessgae: "删除成功", completion: nil)
                } else {
                    print("post request failed with exit code \(result!["code"] as! String)")
                }
            })
            
            momentsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }




}
