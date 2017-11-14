//
//  CircleVCTopicsTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
//定义跳转闭包
typealias pushImageType = (NSArray? , NSNumber?) -> ()
//定义头像个人详情跳转闭包
typealias headImageType = (NSNumber?) -> ()
//定义评论闭包类型
typealias commentType = (_ pid : NSNumber?,_ to_uid : NSNumber?,_ uid : NSNumber?,_ post_id : NSNumber?) -> ()
class CircleVCTopicsTableViewCell: UITableViewCell{
    var   pushImageClouse : pushImageType?
    var   headImagePushClouse  : headImageType?
    var   showCommentClouse : commentType?
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
    var momentsCellModel : NborCircleModel!{
        didSet {
            self.nickName.text = momentsCellModel.user?.nickname
            if let pictureStringArr = momentsCellModel.picture{
                imageHeightConstraint.constant = 100
                let  tap = UITapGestureRecognizer.init(target: self, action:#selector(showImageVC))
                imageLeft.addGestureRecognizer(tap)
                let leftImage = pictureStringArr[0]
                self.imageLeft.sd_setImage(with: URL.init(string: leftImage as! String), placeholderImage: #imageLiteral(resourceName: "spring_view_shadow"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                self.imageRight.isUserInteractionEnabled = false
                self.imageRight.image = nil
                if  pictureStringArr.count >= 2 {
                    self.imageRight.isUserInteractionEnabled = true
                    let  tapSecond = UITapGestureRecognizer.init(target: self, action:#selector(showSecondVC))
                    imageRight.addGestureRecognizer(tapSecond)
                    let rightImage = pictureStringArr[1]
                    self.imageRight.sd_setImage(with: URL.init(string: rightImage as! String), completed: nil)

                }
            }else{
                imageHeightConstraint.constant = 0
            }
            self.textLbl.text = momentsCellModel.content
            self.location.text = momentsCellModel.address
            
            if let  loveNum = momentsCellModel.love {
                self.likeBtn.setTitle("\(loveNum)", for: .normal)
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
    @IBAction func likeBtnClicked(_ sender: UIButton) {
    }
    //评论点击
    @IBAction func commentBtnCell(_ sender: UIButton) {
        if self.showCommentClouse != nil{
            self.showCommentClouse!(0,momentsCellModel.id,momentsCellModel.id,momentsCellModel.pid)
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
   
    override func awakeFromNib() {
        super.awakeFromNib()
        imageHeightConstraint.constant = 0
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
