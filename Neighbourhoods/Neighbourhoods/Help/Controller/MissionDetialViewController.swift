//
//  MissionDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MissionDetialViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var cartifyLbl: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var missionStatusBtn1: UIButton!
    @IBOutlet weak var missionStatusBtn2: UIButton!
    @IBOutlet weak var missionStatusBtn3: UIButton!
    @IBOutlet weak var receiverAvatar: UIImageView!
    @IBOutlet weak var receiveStatusLbl: UILabel!
    
    var viewModel: TaskDetModel? {
        didSet {
            if let avatarStr = viewModel?.user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarStr), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let userName = viewModel?.user?.nickname {
                self.nickName.text = userName
            }
            if let verify = viewModel?.user?.type {
                cartifyLbl.text = " " + verify + " "
            }
            if let location = viewModel?.user?.address {
                if location == "" {
                    self.location.text = location
                    self.locationImg.isHidden = true
                }
            }
            if let gender = viewModel?.user?.sex {
                if gender == 1 {
                    self.gender.image = #imageLiteral(resourceName: "male")
                } else if gender == 2 {
                    self.gender.image = #imageLiteral(resourceName: "female")
                } else {
                    self.gender.isHidden = true
                }
            }
            if let score = viewModel?.integral {
                self.scoreBtn.setTitle("\(score)", for: .normal)
            }
            if let title = viewModel?.title {
                self.titleLbl.text = title
            }
            if let detial = viewModel?.content {
                self.detialLbl.text = detial
            }
            if let receveUserAvatar = viewModel?.receive?.head_pic, let receiveUserInfo = viewModel?.receive?.nickname {
                self.receiverAvatar.sd_setImage(with: URL.init(string: receveUserAvatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
                self.receiveStatusLbl.text = receiveUserInfo + "已领取任务"
            } else {
                self.receiverAvatar.isHidden = true
                self.receiveStatusLbl.isHidden = true
            }
            if let missionStatus = viewModel?.task_status {
                switch missionStatus {
                case 0:
                    missionStatusBtn1.isHidden = true
                    missionStatusBtn2.isHidden = false
                    missionStatusBtn3.isHidden = false
                    
                    missionStatusBtn2.setTitle("待领取", for: .normal)
                    missionStatusBtn2.backgroundColor = mission_complete
                    missionStatusBtn3.setTitle("取消任务", for: .normal)
                    missionStatusBtn3.backgroundColor = mission_going
                case 1:
                    missionStatusBtn1.isHidden = false
                    missionStatusBtn2.isHidden = true
                    missionStatusBtn3.isHidden = true
                    
                    missionStatusBtn1.setTitle("进行中", for: .normal)
                    missionStatusBtn1.backgroundColor = mission_going
                case 2:
                    missionStatusBtn1.isHidden = true
                    missionStatusBtn2.isHidden = false
                    missionStatusBtn3.isHidden = false
                    
                    missionStatusBtn2.setTitle("确认完成", for: .normal)
                    missionStatusBtn2.backgroundColor = mission_complete
                    missionStatusBtn3.setTitle("驳回", for: .normal)
                    missionStatusBtn3.backgroundColor = mission_going
                case 3:
                    missionStatusBtn1.isHidden = false
                    missionStatusBtn2.isHidden = true
                    missionStatusBtn3.isHidden = true
                    
                    missionStatusBtn1.setTitle("已确认", for: .normal)
                    missionStatusBtn1.backgroundColor = mission_complete
                case 4:
                    missionStatusBtn1.isHidden = false
                    missionStatusBtn2.isHidden = true
                    missionStatusBtn3.isHidden = true
                    
                    missionStatusBtn1.setTitle("已驳回", for: .normal)
                    missionStatusBtn1.backgroundColor = mission_complete
                default: break
                }
            }
            
        }
        
    }
    
    var id: Int? {
        didSet {
            let token = UserDefaults.standard.string(forKey: "token")
            guard let id = self.id else {
                return
            }

            NetWorkTool.shareInstance.taskDet(token!, id: id) { [weak self](info, error) in
                if info?["code"] as? String == "200"{
                    let result = info!["result"] as! NSDictionary
                    self?.viewModel = TaskDetModel.mj_object(withKeyValues: result)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    


}
