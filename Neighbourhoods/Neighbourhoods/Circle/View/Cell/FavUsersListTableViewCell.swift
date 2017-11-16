//
//  UsersListTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class FavUsersListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var alreadyFollowLbl: UILabel!
    @IBOutlet weak var addFollowView: UIView!
    var viewModel: AttentionAndFansModel? {
        didSet {
            if let avatatStr = viewModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatatStr), placeholderImage: #imageLiteral(resourceName: "notice_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.nickname {
                self.nickName.text = name
            }
            if let verify = viewModel?.type {
                self.verifyLbl.text = verify
            }
            if let gender = viewModel?.sex {
                if gender == 1 {
                    self.gender.image = #imageLiteral(resourceName: "male")
                } else if gender == 2  {
                    self.gender.image = #imageLiteral(resourceName: "female")
                }
            }

            self.location.text = ""
            
            if let isFollowing = viewModel?.is_atten {
                if isFollowing == 1 {
                    alreadyFollowLbl.isHidden = false
                    addFollowView.isHidden    = true
                } else {
                    alreadyFollowLbl.isHidden = true
                    addFollowView.isHidden    = false
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cancelGes = UITapGestureRecognizer(target: self, action: #selector(cancelFollow))
        alreadyFollowLbl.addGestureRecognizer(cancelGes)
        
        let addFollowGes = UITapGestureRecognizer(target: self, action: #selector(addFollow))
        addFollowView.addGestureRecognizer(addFollowGes)
        
    }
    
    @objc func addFollow() {
        alreadyFollowLbl.isHidden = false
        addFollowView.isHidden    = true
        guard self.viewModel?.uid  != nil else{
            return
        }
        userClickChangeFollowStatus(uid: self.viewModel?.uid! as! Int, type: 1)
        //        userClickChangeFollowStatus(uid: 1, type: 1)
    }
    
    @objc func cancelFollow() {
        alreadyFollowLbl.isHidden = true
        addFollowView.isHidden    = false
        guard self.viewModel?.uid  != nil else{
            return
        }
        userClickChangeFollowStatus(uid: self.viewModel?.uid! as! Int, type: 2)
    }
    
    func userClickChangeFollowStatus(uid: Int, type: Int) {
        
        let token = UserDefaults.standard.string(forKey: "token")
        NetWorkTool.shareInstance.changeFollowStatus(token!, uid: uid, type: type) { (result, error) in
            if error != nil {
                print(error as AnyObject)
                return
            }
            
            switch result!["code"] as! String {
            case "200" : print("关注成功")
            case "400" : print("关注失败, 取消关注成功")
            case "402" : print("请传入type参数")
            default    : break
            }
        }
        
    }
    
    
   
    
}
