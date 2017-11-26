//
//  MomentsCommentDetialSpecificCommentTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
import NoticeBar
//定义跳转闭包
typealias pushDetailVCType = (NSNumber?) -> ()
typealias MonentCommentDetailSpecHeadImageType = (NSNumber?) -> ()
typealias commentSecondaryDetialType = (_ pid : NSNumber?,_ to_uid : NSNumber?,_ uid : NSNumber?,_ post_id : NSNumber?) -> ()
class MomentsCommentDetialSpecificCommentTableViewCell: UITableViewCell {
    var  headImagePushClouse   : MonentCommentDetailSpecHeadImageType?
    var  showCommentClouse     : commentSecondaryDetialType?
    @IBOutlet weak var commentMoreBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentDetailHeight: NSLayoutConstraint!
    var momentsCellModel : NborCircleModel!{
        didSet {
            self.nickName.text = momentsCellModel.user_info?.nickname
            self.textLbl.text = momentsCellModel.content
            let userModel =  momentsCellModel.user_info
            if let avatarString  =  userModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                let  headImageTap = UITapGestureRecognizer.init(target: self, action:#selector(showUserInfoVC))
                avatar.addGestureRecognizer(headImageTap)
              
            }
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
            if  let repairDetail = momentsCellModel.info {
                    commentCountLbl.text = "  " + repairDetail
                    commentDetailHeight.constant = 40
            }else{
                     commentDetailHeight.constant = 0
            }
        }
    }
    var pushClouse : pushDetailVCType?
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        guard let   id  =  self.momentsCellModel.id else{
            return
        }
        guard let  nbor_id  =  self.momentsCellModel.nbor_id else{
            return
        }
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
          NetWorkTool.shareInstance.nbor_comtZan(token: UserDefaults.standard.string(forKey: "token")!, nbor_id: nbor_id, id: id) { [weak self](info, error) in
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
    @IBAction func shareBtnClicked(_ sender: UIButton) {
    }
    @IBAction func showCommentDetail(_ sender: Any) {
        if self.pushClouse != nil{
            self.pushClouse!(self.momentsCellModel.id)
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
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
