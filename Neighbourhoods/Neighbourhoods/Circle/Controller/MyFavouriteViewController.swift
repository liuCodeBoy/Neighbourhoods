//
//  MyFavouriteViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 24/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyFavouriteViewController: UIViewController {
    lazy var  rotaionArray = [NborCircleModel]()
    @IBOutlet weak var myFavTableView: UITableView!
    @IBOutlet weak var favMoments: UIButton!
    @IBOutlet weak var favUsers: UIButton!
    var favUserTableView: UIView?
    var favUserErrorView : UIView?
    let coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    @IBAction func btn1clicked(_ sender: UIButton) {
        
        // MARK:- change button control state
        favMoments.isSelected = true
        favUsers.isSelected = false
        // MARK:- hide the user list table view
        favUserTableView?.isHidden = true
        favUserErrorView?.isHidden = true
        
    }
    
    @IBAction func btn2clicked(_ sender: UIButton) {
        favMoments.isSelected = false
        favUsers.isSelected = true
        // MARK:- reveal the user list table view
        favUserTableView?.isHidden = false
        favUserErrorView?.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        setNavBarTitle(title: "我的关注")
        myFavTableView.delegate = self
        myFavTableView.dataSource = self
        loadFavUserVC()
        favUserTableView?.isHidden = true
        favUserErrorView?.isHidden = true
        lastedRequest()
        
        // MARK:- adjust tableview height
        self.myFavTableView.estimatedRowHeight = 200
        self.myFavTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    // MARK:- initialize the user list table view and controller
    func loadFavUserVC() {
        let childVC = self.storyboard?.instantiateViewController(withIdentifier: "FavUsersListVC") as! FavUsersListViewController
        let tableView = childVC.view
        favUserTableView = tableView
        favUserErrorView = childVC.coverView
        var y = (favMoments.superview?.frame.maxY)! + 1
        if isIPHONEX { y += 24 }
        tableView?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y - 49)
        self.addChildViewController(childVC)
        self.view.addSubview(tableView!)
    }
    
    //MARK: - 最新发布网络请求
    func lastedRequest() -> () {
        var token = ""
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        token = UserDefaults.standard.string(forKey: "token")!
        NetWorkTool.shareInstance.atten_nbor(token, uid: UserDefaults.standard.integer(forKey: "uid")) {[weak self](info, error) in
        
            if info?["code"] as? String == "200"{
                guard let result  = info!["result"] as? [NSDictionary] else {
                    self?.coverView.showLab.text = "暂无动态"
                    self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    self?.myFavTableView.addSubview((self?.coverView)!)
                    return
                }
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                self?.myFavTableView.reloadData()
              
            }else{
                //服务器
             
            }
        }
    }
    
}

extension MyFavouriteViewController : UITableViewDelegate , UITableViewDataSource{

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.rotaionArray.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsLatestIssueCell") as! MomentsLatestIssueTableViewCell
        let modelArr =  self.rotaionArray
        guard  modelArr.count > 0 else {
            return cell
        }
        let  model =  modelArr[indexPath.row]       
        cell.momentsCellModel = model
        cell.pushImageClouse = {(imageArr, index) in
            let desVC = UIStoryboard(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "ImageShowVCID") as!  ImageShowVC
            desVC.index  = index
            desVC.imageArr = imageArr
            self.present(desVC, animated: true, completion: nil)
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
        cell.showCommentClouse = {(pid ,to_uid ,uid,post_id) in
            let commentVc = self.storyboard?.instantiateViewController(withIdentifier: "WriteCommentIdent") as? WriteCommentViewController
            commentVc?.pid = 0
            commentVc?.to_uid  = model.uid
            commentVc?.uid     = model.uid
            commentVc?.post_id = model.id
            self.navigationController?.pushViewController(commentVc!, animated: true)
        }
        return cell

    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let   momentsCommentDetialVC =  UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "MomentsCommentDetialViewController") as! MomentsCommentDetialViewController
        let modelArr =  self.rotaionArray
        guard modelArr.count > 0  else {
            return
        }
        let  model =  modelArr[indexPath.row]
        momentsCommentDetialVC.id = model.id
        self.navigationController?.pushViewController(momentsCommentDetialVC, animated: true)
    }
 

}

