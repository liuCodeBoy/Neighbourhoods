//
//  MomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class MomentsViewController: UIViewController {
    
    @IBOutlet weak var latestIssue: UIButton!
    @IBOutlet weak var hotestTopic: UIButton!
    @IBOutlet weak var topicClassify: UIButton!
    @IBOutlet weak var topicsView: UIView!
    @IBAction func btn1clicked(_ sender: UIButton) {
        latestIssue.isSelected = true
        hotestTopic.isSelected = false
        topicClassify.isSelected = false
        topicsView.isHidden = true
    }
    @IBAction func btn2clicked(_ sender: UIButton) {
        latestIssue.isSelected = false
        hotestTopic.isSelected = true
        topicClassify.isSelected = false
        topicsView.isHidden = true
    }
    @IBAction func btn3clicked(_ sender: UIButton) {
        latestIssue.isSelected = false
        hotestTopic.isSelected = false
        topicClassify.isSelected = true
        topicsView.isHidden = false
    }
    
    @IBOutlet weak var momentsTopicsTableView: UITableView!
    lazy var  rotaionArray = [NborCircleModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavItems()
        topicsView.isHidden = true
        momentsTopicsTableView.delegate = self
        momentsTopicsTableView.dataSource = self
        //默认下拉刷新
//        momentsTopicsTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: nil)
//         self.momentsTopicsTableView.mj_header.beginRefreshing()
        
        NetWorkTool.shareInstance.nbor_list(Nbor_Sort.time, p: 1) {[weak self](info, error) in

            if info?["code"] as? String == "200"{
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo) {
                        self?.rotaionArray.append(rotationModel)
                   
                    }
                }
                self?.momentsTopicsTableView.reloadData()
           }
        }
        
  
    }

   
    
    func loadNavItems() {
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: .done, target: self, action: #selector(pop))
        self.navigationItem.setLeftBarButton(backBtn, animated: true)
        self.setNavBarTitle(title: "圈内动态")
        
        let writeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_write_message"), style: .done, target: self, action: #selector(writeMessgae))
        let messgaeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_message"), style: .done, target: self, action: #selector(lookUpMessage))
        // MARK:- set right items
        self.navigationItem.setRightBarButtonItems([messgaeBtn, writeBtn], animated: true)

    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func writeMessgae() {
        
    }
    
    @objc func lookUpMessage() {
        
    }
    
    

}


extension MomentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rotaionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsTopicCell") as!  MomentsVCLatestIssueTableViewCell
       
        let  model =  rotaionArray[indexPath.row]
        cell.momentsCellModel = model
        return cell
    }
}
