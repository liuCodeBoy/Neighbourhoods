//
//  ActivityVoteEndedViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 04/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class ActivityVoteEndedViewController: UIViewController {
    //投票详情id
    var  id : NSNumber?
    var  model : VoteActDet?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var detialTextLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lastedRequest(id: id as! Int)
        setNavBarTitle(title: "投票")
        setNavBarBackBtn()
    }
   
    @IBAction func ShowEndDetailVC(_ sender: Any) {
        guard model != nil else{
            return
        }
        if model?.cate == 2 {
        let  showEndDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowVoteActivResultID") as! ShowVoteActivResult
        showEndDetailVC.cate = model?.cate
        showEndDetailVC.id = model?.id
        showEndDetailVC.status = model?.status
        self.navigationController?.pushViewController(showEndDetailVC, animated: true)
        }else{
            let  showEndDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowFigureVotResultVCID") as! ShowFigureVotResultVC
            showEndDetailVC.cate = model?.cate
            showEndDetailVC.id = model?.id
            showEndDetailVC.status = model?.status
            self.navigationController?.pushViewController(showEndDetailVC, animated: true)
            
        }
    
        
    }
    //MARK: - 最新发布网络请求
    func lastedRequest(id : Int) -> () {
        NetWorkTool.shareInstance.act_det(id: id) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                let result  = info!["result"] as! NSDictionary
                if  let rotationModel = VoteActDet.mj_object(withKeyValues: result){
                    self?.model = rotationModel
                    if let avatarString  =  rotationModel.picture {
                        self?.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                    }
                    if let  title = rotationModel.title {
                        self?.activityName.text = title
                    }
                    if let  local = rotationModel.host {
                        self?.locationLbl.text = local
                    }
                    if let  phone = rotationModel.phone {
                        self?.phoneNumber.text = phone
                    }
                    if let  email = rotationModel.email {
                        self?.emailAddress.text = email
                    }
                    if let  content = rotationModel.content {
                        self?.detialTextLbl.text = content
                    }
                }
            }else{
                //服务器
            }
        }
    }
}
