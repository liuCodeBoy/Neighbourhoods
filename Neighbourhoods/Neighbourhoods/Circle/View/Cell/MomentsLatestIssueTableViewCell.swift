//
//  MomentsLatestIssueTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
import NoticeBar
//定义跳转闭包
typealias MonentImageType = (NSArray? , NSNumber?) -> ()
//定义头像个人详情跳转闭包
typealias MonentHeadImageType = (NSNumber?) -> ()
//定义评论闭包类型
typealias commentLatestIssueType = (_ pid : NSNumber?,_ to_uid : NSNumber?,_ uid : NSNumber?,_ post_id : NSNumber?) -> ()
class MomentsLatestIssueTableViewCell: UITableViewCell {
    var   pushImageClouse : MonentImageType?
     var  headImagePushClouse   : MonentHeadImageType?
    var   showCommentClouse : commentLatestIssueType?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var certifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var imageRight: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        let  nbor_id  =  self.momentsCellModel.id
        guard UserDefaults.standard.string(forKey: "token") != nil else{
            let config = NoticeBarConfig(title: "你还未登录,请退出游客模式", image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.0, completed: {
                (finished) in
                if finished {
                }
            })
            return
        }
        NetWorkTool.shareInstance.nbor_zan(token: UserDefaults.standard.string(forKey: "token")!, nbor_id: nbor_id!) { [weak self](info, error) in
            if info?["code"] as? String == "400"{
                let config = NoticeBarConfig(title: "你已点赞", image: nil, textColor: UIColor.white, backgroundColor: UIColor.gray, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.25, completed: {
                    (finished) in
                    if finished {
                    }
                })
            }else if (info?["code"] as? String == "200"){
                //服务器
                self?.likeBtn.setTitle("\(Int(truncating: (self?.momentsCellModel.love!)!) + 1)", for: .normal)
            }
        }
    }
    @IBAction func commentBtnCell(_ sender: UIButton) {
        if self.showCommentClouse != nil{
            self.showCommentClouse!(0,momentsCellModel.id,momentsCellModel.id,momentsCellModel.pid)
        }
        self.commentBtn.setTitle("\(Int(truncating: self.momentsCellModel.comment!) + 1)", for: .normal)
    }
    
    var momentsCellModel : NborCircleModel!{
        didSet {
            self.nickName.text = momentsCellModel.user?.nickname
            if let pictureStringArr = momentsCellModel.picture{
                imageHeightConstraint.constant = 90
                let leftImage = pictureStringArr[0]
                self.imageLeft.sd_setImage(with: URL.init(string: leftImage as! String), placeholderImage: #imageLiteral(resourceName: "spring_view_shadow"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                let  tap = UITapGestureRecognizer.init(target: self, action:#selector(showImageVC))
                imageLeft.addGestureRecognizer(tap)
                self.imageRight.isUserInteractionEnabled = false
                self.imageRight.image = nil
                if  pictureStringArr.count >= 2 {
                 let rightImage = pictureStringArr[1]
                 self.imageRight.isUserInteractionEnabled = true
                 let  tapSecond = UITapGestureRecognizer.init(target: self, action:#selector(showSecondVC))
                 imageRight.addGestureRecognizer(tapSecond)
                 self.imageRight.sd_setImage(with: URL.init(string: rightImage as! String), completed: nil)
                  }
               
            }else{
                imageHeightConstraint.constant = 0
            }
            if let  loveNum = momentsCellModel.love {
                self.likeBtn.setTitle("\(loveNum)", for: .normal)
            }
            if let  commentNum = momentsCellModel.comment{
                self.commentBtn.setTitle("\(commentNum)", for: .normal)
            }
            self.textLbl.text = momentsCellModel.content
            self.location.text = momentsCellModel.address
            
            if let timeNum = momentsCellModel.time {
                self.createTime.text = NSDate.createDateString(createAtStr: "\(timeNum)")
            }
            let userModel =  momentsCellModel.user
            self.certifyLbl.text = userModel?.is_admin
            if let avatarString  =  userModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                let  headImageTap = UITapGestureRecognizer.init(target: self, action:#selector(showUserInfoVC))
                avatar.addGestureRecognizer(headImageTap)
            }
            let  sex = userModel?.sex?.intValue
            if sex == 1 || sex == 2 {
                self.gender.image =   sex == 1 ? UIImage.init(named: "male") : UIImage.init(named: "female")
            }else{
            }
            
        }
    }

    
    @objc private func showImageVC(){
        if let pictureStringArr = momentsCellModel.picture{
            if self.pushImageClouse != nil{
                self.pushImageClouse!(pictureStringArr ,0)
            }
        }
    }
    @objc private func showSecondVC(){
        if let pictureStringArr = momentsCellModel.picture{
            if self.pushImageClouse != nil{
                self.pushImageClouse!(pictureStringArr ,1)
            }
        }
    }
    //点击头像
    @objc private func showUserInfoVC(){
        if let  otherID = self.momentsCellModel.uid {
            if self.headImagePushClouse != nil {
                self.headImagePushClouse!(otherID)
            }
        }
    }
}
