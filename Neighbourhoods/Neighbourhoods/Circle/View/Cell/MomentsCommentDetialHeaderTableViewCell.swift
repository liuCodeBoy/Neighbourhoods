//
//  MomentsCommentDetialHeaderTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
import NoticeBar
typealias MonentDetailHeaderHeadImageType = (NSNumber?) -> ()
typealias MonentDetialHeaderImageType = (NSArray? , NSNumber?) -> ()
typealias commentSecondaryHeaderType = (_ pid : NSNumber?,_ to_uid : NSNumber?,_ uid : NSNumber?,_ post_id : NSNumber?) -> ()
class MomentsCommentDetialHeaderTableViewCell: UITableViewCell {
    var  headImagePushClouse   : MonentDetailHeaderHeadImageType?
    var   pushImageClouse : MonentDetialHeaderImageType?
    var  showCommentClouse     : commentSecondaryHeaderType?
    var  isTopic : NSInteger?
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
        if self.isTopic == nil{
            nborZan()
        }else{
            topicZan()
        }
    
    }
    
    
    func nborZan(){
        let  nbor_id  =  self.momentsCellModel.id
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
                self?.likeBtn.isSelected = true
            }
        }
    }
    
    func  topicZan(){
        let  nbor_id  =  self.momentsCellModel.id
        NetWorkTool.shareInstance.topic_zan(token: UserDefaults.standard.string(forKey: "token")!, nbor_id: nbor_id!) { [weak self](info, error) in
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
                self?.likeBtn.isSelected = true
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
                let leftImage = pictureStringArr[0] as! String
                if leftImage.count > 1 {
                imageHeightConstraint.constant = 90
                self.imageLeft.sd_setImage(with: URL.init(string: leftImage), placeholderImage: #imageLiteral(resourceName: "img_loading_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                //print(leftImage)
                let  tap = UITapGestureRecognizer.init(target: self, action:#selector(showImageVC))
                imageLeft.addGestureRecognizer(tap)
                self.imageRight.isUserInteractionEnabled = false
                self.imageRight.image = nil
                if  pictureStringArr.count >= 2 {
                    let rightImage = pictureStringArr[1]
                    self.imageRight.isUserInteractionEnabled = true
                    self.imageRight.sd_setImage(with: URL.init(string: rightImage as! String), completed: nil)
                    let  tapSecond = UITapGestureRecognizer.init(target: self, action:#selector(showSecondVC))
                    imageRight.addGestureRecognizer(tapSecond)
              }
                }else{
                imageHeightConstraint.constant = 0
            }
            }else{
                imageHeightConstraint.constant = 0
            }
            self.textLbl.text = momentsCellModel.content
            self.location.text = momentsCellModel.address
            if let  loveNum = momentsCellModel.love {
                self.likeBtn.setTitle("\(loveNum)", for: .normal)
            }
            if momentsCellModel.is_zan == 1 {
                self.likeBtn.isSelected = true
            }else{
                self.likeBtn.isSelected = false
            }
            if let  commentNum = momentsCellModel.comment{
                self.commentBtn.setTitle("\(commentNum)", for: .normal)
            }
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
