//
//  MomentsCommentDetialSpecificCommentTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
//定义跳转闭包
typealias pushDetailVCType = (NSNumber?) -> ()
typealias MonentCommentDetailSpecHeadImageType = (NSNumber?) -> ()
class MomentsCommentDetialSpecificCommentTableViewCell: UITableViewCell {
    var  headImagePushClouse   : MonentCommentDetailSpecHeadImageType?
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
            self.nickName.text = momentsCellModel.user?.nickname
            self.textLbl.text = momentsCellModel.content
            let userModel =  momentsCellModel.user
            if let avatarString  =  userModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                let  headImageTap = UITapGestureRecognizer.init(target: self, action:#selector(showUserInfoVC))
                avatar.addGestureRecognizer(headImageTap)
              
            }
            if let  loveNum = momentsCellModel.love {
                self.likeBtn.setTitle("\(loveNum)", for: .normal)
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
    }
    @IBAction func commentBtnCell(_ sender: UIButton) {
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
