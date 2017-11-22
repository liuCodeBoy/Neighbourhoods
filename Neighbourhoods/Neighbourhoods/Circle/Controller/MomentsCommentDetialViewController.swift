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
       
   
    }
    override func viewWillAppear(_ animated: Bool) {
        //发起网络请求
        momentsComDetListArray.removeAll()

        //发起网络请求
        showDetailInfo()
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsCommentDetialHeaderCell") as! MomentsCommentDetialHeaderTableViewCell
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
                commentVc?.pid =  0
                commentVc?.to_uid  = self?.detailMainModel?.uid
                commentVc?.uid     = self?.detailMainModel?.uid
                commentVc?.post_id = self?.detailMainModel?.id
                self?.navigationController?.pushViewController(commentVc!, animated: true)
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
