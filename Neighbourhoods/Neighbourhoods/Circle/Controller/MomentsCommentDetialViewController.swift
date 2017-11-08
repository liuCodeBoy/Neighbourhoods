//
//  MomentsCommentDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
class MomentsCommentDetialViewController: UIViewController {

    var  id               : NSNumber?
    var detailMainModel   : NborCircleModel?
    lazy var  momentsComDetListArray = [NborCircleModel]()
    
    @IBOutlet weak var momentsCommentDetialTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        setNavBarTitle(title: "圈内动态")
        //自动计算高度
        momentsCommentDetialTableView.estimatedRowHeight = 100
        momentsCommentDetialTableView.rowHeight = UITableViewAutomaticDimension
        //发起网络请求
        showDetailInfo()
        //执行cell跳转闭包
        action()
    }
    
    func action() -> () {
        
        
    }
    
    func showDetailInfo() -> () {
        NetWorkTool.shareInstance.nbor_Detail(id: self.id as! NSInteger ) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                let result  = info!["result"] as? [String : Any]
                self?.detailMainModel = NborCircleModel.mj_object(withKeyValues: result)
                let commentListArr = result!["comment_list"] as? [[String : Any]]
                for  comment  in commentListArr! {
                    if  let model = NborCircleModel.mj_object(withKeyValues: comment){
                    self?.momentsComDetListArray.append(model)
                    }
                }
                self?.momentsCommentDetialTableView.reloadData()
            }else{
                //服务器
             }
           }
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 175
//        } else {
//            return 150
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsCommentDetialHeaderCell") as! MomentsCommentDetialHeaderTableViewCell
            if detailMainModel != nil {
            cell.momentsCellModel = detailMainModel
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsCommentDetialSpecificCommentCell") as? MomentsCommentDetialSpecificCommentTableViewCell
            cell?.pushClouse = {(id) in
                let desVC = UIStoryboard(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "SecondaryCommentTable") as!  SecondaryCommentTableViewController
                desVC.id = id
                self.navigationController?.pushViewController(desVC, animated: true)
            }
            let  model = self.momentsComDetListArray[indexPath.row]
            cell?.momentsCellModel = model
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
