//
//  MomentsCommentDetialHeaderTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
typealias MonentDetailHeaderHeadImageType = (NSNumber?) -> ()
typealias MonentDetialHeaderImageType = (NSArray? , NSNumber?) -> ()
class MomentsCommentDetialHeaderTableViewCell: UITableViewCell {
    var  headImagePushClouse   : MonentDetailHeaderHeadImageType?
    var   pushImageClouse : MonentDetialHeaderImageType?
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
    }
    @IBAction func commentBtnCell(_ sender: UIButton) {
    }
    var momentsCellModel : NborCircleModel!{
        didSet {
            self.nickName.text = momentsCellModel.user?.nickname
            if let pictureStringArr = momentsCellModel.picture{
                let leftImage = pictureStringArr[0] as! String
                if leftImage.characters.count > 1 {
                imageHeightConstraint.constant = 90
                self.imageLeft.sd_setImage(with: URL.init(string: leftImage), placeholderImage: #imageLiteral(resourceName: "spring_view_shadow"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                print(leftImage)
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
