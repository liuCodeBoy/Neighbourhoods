//
//  ActivityVoteConsultingViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class ActivityVoteConsultingViewController: UIViewController {
    var  id : NSNumber?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var detialTextLbl: UILabel!
    
    @IBAction func addComment(_ sender: UIButton) {
        self.navigationController?.pushViewController(CommentViewController(), animated: true)
    }
    
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "某正在协商的活动")
        lastedRequest(id : id as! Int)
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


extension ActivityVoteConsultingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ActivityConsultingCommentCell")!
    }
}
