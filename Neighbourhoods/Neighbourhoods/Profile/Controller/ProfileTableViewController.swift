//
//  ProfileTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followerCountLbl: UILabel!
    @IBOutlet weak var scoreCountLbl: UILabel!
    @IBOutlet weak var scoreLevelImg: UIImageView!
    @IBOutlet weak var scoreIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setNavBarTitle(title: "我的")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        //print(access_token)
        NetWorkTool.shareInstance.userInfo(access_token) { [weak self](result, error) in
            if error != nil {
                //print(error as Any)
            } else if result?["code"] as! String == "200" {
                let resultDict = result!["result"] as! [String: AnyObject]
                self?.viewModel = UserInfoModel.mj_object(withKeyValues: resultDict)
            }
        }
    }
    
    
    var viewModel: UserInfoModel? {
        didSet {
            if let avatatStr = viewModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatatStr), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
                userAvatar.sd_setImage(with: URL.init(string: avatatStr), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let level = viewModel?.level {
                switch level {
                case 1:
                    scoreLevelImg.image = #imageLiteral(resourceName: "score_rookie")
                    scoreIcon.image = #imageLiteral(resourceName: "score_icon_rookie")
                case 2:
                    scoreLevelImg.image = #imageLiteral(resourceName: "score_three")
                    scoreIcon.image = #imageLiteral(resourceName: "star_3")
                case 3:
                    scoreLevelImg.image = #imageLiteral(resourceName: "score_four")
                    scoreIcon.image = #imageLiteral(resourceName: "star_4")
                case 4:
                    scoreLevelImg.image = #imageLiteral(resourceName: "score_five")
                    scoreIcon.image = #imageLiteral(resourceName: "star_5")
                case 5:
                    scoreLevelImg.image = #imageLiteral(resourceName: "score_gold")
                    scoreIcon.image = #imageLiteral(resourceName: "score_icon_gold")
                case 6:
                    scoreLevelImg.image = #imageLiteral(resourceName: "score_diamond")
                    scoreIcon.image = #imageLiteral(resourceName: "score_icom_diamond")
                default:
                    scoreLevelImg.image = #imageLiteral(resourceName: "score_rookie")
                    scoreIcon.image = #imageLiteral(resourceName: "score_icon_rookie")
                }
            }
            if let verify = viewModel?.type {
                self.verifyLbl.text = verify
            }
            if let name = viewModel?.nickname {
                self.nickName.text = name
            }
            if let gender = viewModel?.sex {
                if gender == 1 {
                    self.gender.image = #imageLiteral(resourceName: "male")
                } else if gender == 2  {
                    self.gender.image = #imageLiteral(resourceName: "female")
                }
            }
            if let location = viewModel?.address {
                self.locationBtn.setTitle(location, for: .normal)
            } else {
                self.locationBtn.isHidden = true
            }
            if let following = viewModel?.atten {
                self.followingCountLbl.text = "\(following)"
            }
            if let follower = viewModel?.fans {
                self.followerCountLbl.text = "\(follower)"
            }
            if let score = viewModel?.integral {
                self.scoreCountLbl.text = "\(score)"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scoreSegue" {
            let dest = segue.destination as! MyScoreViewController
            dest.score = self.scoreCountLbl.text
        }
    }

}
