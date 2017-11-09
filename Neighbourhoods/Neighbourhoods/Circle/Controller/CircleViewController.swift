//
//  CircleViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 14/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class CircleViewController: UIViewController {
    @IBOutlet weak var topicsTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBarItem!
    var page  = 1
    var pages : Int?
    lazy var  rotaionArray = [NborCircleModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicsTableView.estimatedRowHeight = 50
        topicsTableView.rowHeight = UITableViewAutomaticDimension
        loadRefreshComponet()
        lastedRequest(p : page)
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        let URLArr = [URL(string: "http://ow1i9ri5b.bkt.clouddn.com/Screen%20Shot%202017-10-21%20at%205.35.48%20PM.png"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/IMG_7944.jpg"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/prototype-design-white.png"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/Sombrero.jpg")]
        let  loopView = LoopView.init(images: URLArr as! [URL], frame: CGRect.init(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 160), isAutoScroll: true)
        self.view.addSubview(loopView)
    }
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        topicsTableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        topicsTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        topicsTableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        topicsTableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
        topicsTableView.reloadData()
        topicsTableView.mj_header.endRefreshing()
        
    }
    @objc func  endrefresh() -> (){
        lastedRequest(p: page)
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        NetWorkTool.shareInstance.nbor_list(Nbor_Sort.love, p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                {
                    self?.pages = (pages as! Int)
                }
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                }
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                self?.topicsTableView.reloadData()
                if self?.page == self?.pages {
                    self?.topicsTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }else{
                //服务器
                self?.topicsTableView.mj_header.endRefreshing()
                self?.topicsTableView.mj_footer.endRefreshing()
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

extension CircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.rotaionArray.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotTopicsCell") as! CircleVCTopicsTableViewCell
        let modelArr =  self.rotaionArray
        let  model =  modelArr[indexPath.row]
        cell.momentsCellModel = model
        cell.pushImageClouse = {(imageArr, index) in
        let desVC = UIStoryboard(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "ImageShowVCID") as!  ImageShowVC
        desVC.index  = index
        desVC.imageArr = imageArr
        self.navigationController?.pushViewController(desVC, animated: true)
    }
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let   momentsCommentDetialVC =  UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "MomentsCommentDetialViewController") as! MomentsCommentDetialViewController
        let modelArr =  self.rotaionArray
        let  model =  modelArr[indexPath.row]
        momentsCommentDetialVC.id = model.id
        self.navigationController?.pushViewController(momentsCommentDetialVC, animated: true)
    }
}





    

            


    


