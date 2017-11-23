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
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var detialTextLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lastedRequest(id: id as! Int)
    }
   
    @IBAction func ShowEndDetailVC(_ sender: Any) {
    }
    //MARK: - 最新发布网络请求
    func lastedRequest(id : Int) -> () {
        NetWorkTool.shareInstance.act_det(id: id) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                let result  = info!["result"] as! NSDictionary
                if  let rotationModel = VoteActDet.mj_object(withKeyValues: result){
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
