//
//  ProfileFollowerTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 10/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ProfileFollowerTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var alreadyFollowLbl: UILabel!
    @IBOutlet weak var addFollowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cancelGes = UITapGestureRecognizer(target: self, action: #selector(cancelFollow))
        alreadyFollowLbl.addGestureRecognizer(cancelGes)
        alreadyFollowLbl.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        
        let addFollowGes = UITapGestureRecognizer(target: self, action: #selector(addFollow))
        addFollowView.addGestureRecognizer(addFollowGes)
        
    }
    
    @objc func addFollow() {
        alreadyFollowLbl.isHidden = false
        addFollowView.isHidden    = true
        userClickChangeFollowStatus(uid: self.viewModel?.uid! as! Int, type: 1)
    }
    
    @objc func cancelFollow() {
        alreadyFollowLbl.isHidden = true
        addFollowView.isHidden    = false
        userClickChangeFollowStatus(uid: self.viewModel?.uid! as! Int, type: 2)
        
    }
    
    func userClickChangeFollowStatus(uid: Int, type: Int) {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.changeFollowStatus(access_token, uid: uid, type: type) { (result, error) in
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
//        let tableView = self.superview as! UITableView
//        tableView.reloadData()
        
    }
    
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
            
            // FIXME: - location bug
//            if let location = viewModel? {
//            self.locationBtn.setTitle(location, for: .normal)
//            } else {
//                self.locationBtn.isHidden = true
//            }
//            self.location.text = ""
            
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
}
