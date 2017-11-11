//
//  TopicDetialTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
typealias MonentDetialImageType = (NSArray? , NSNumber?) -> ()
class TopicDetialTableViewCell: UITableViewCell {
    var   pushImageClouse : MonentDetialImageType?
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
    var title : String?
    @IBAction func likeBtnClicked(_ sender: UIButton) {
    }
    @IBAction func commentBtnCell(_ sender: UIButton) {
    }
    var TopicDetialModel : NborCircleModel!{
        didSet {
            if let avatarString  =  TopicDetialModel?.user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
            }
            self.nickName.text = TopicDetialModel.user?.nickname
            self.certifyLbl.text = TopicDetialModel?.user?.type
            if let  sex = TopicDetialModel?.user?.sex?.intValue {
            if sex == 1 || sex == 2 {
                self.gender.image =   sex == 1 ? UIImage.init(named: "male") : UIImage.init(named: "female")
              }else{
             }
            }
            if let timeNum = TopicDetialModel.time {
                self.createTime.text = NSDate.createDateString(createAtStr: "\(timeNum)")
            }
            if let topicStr = TopicDetialModel.content{
            if let titleTheme = self.title{
            let str = NSMutableAttributedString(string: titleTheme + topicStr)
            let strNum = titleTheme.characters.count
            let range  = Range.init(0...strNum-1)
            str.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue ,NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 18)], range: NSRange.init(range))
            self.textLbl.attributedText = str
             }
          
            }
            if let  likeNum = TopicDetialModel.love{
                self.likeBtn.titleLabel?.text = "\(String(describing: likeNum))"
            }
            if let  comment = TopicDetialModel.comment{
                self.commentBtn.titleLabel?.text = "\(String(describing: comment))"
            }
            if let pictureStringArr = TopicDetialModel?.picture{
                imageHeightConstraint.constant = 90
                let leftImage = pictureStringArr[0]
                self.imageLeft.sd_setImage(with: URL.init(string: leftImage as! String), placeholderImage: #imageLiteral(resourceName: "spring_view_shadow"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                let  tap = UITapGestureRecognizer.init(target: self, action:#selector(showImageVC))
                imageLeft.addGestureRecognizer(tap)
                 self.imageRight.image = nil
                 self.imageRight.isUserInteractionEnabled = false
                if  pictureStringArr.count >= 2 {
                      let  rightImage = pictureStringArr[1]
                      self.imageRight.isUserInteractionEnabled = true
                      self.imageRight.sd_setImage(with: URL.init(string: rightImage as! String), placeholderImage: #imageLiteral(resourceName: "spring_view_shadow"),options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                    let  tapSecond = UITapGestureRecognizer.init(target: self, action:#selector(showSecondVC))
                    imageRight.addGestureRecognizer(tapSecond)
                }
            }else{
                imageHeightConstraint.constant = 0
            }
        }
    }

    @objc private func showImageVC(){
        if let pictureStringArr = TopicDetialModel.picture{
            if self.pushImageClouse != nil{
                self.pushImageClouse!(pictureStringArr ,0)
            }
        }
    }
    @objc private func showSecondVC(){
        if let pictureStringArr = TopicDetialModel.picture{
            if self.pushImageClouse != nil{
                self.pushImageClouse!(pictureStringArr ,1)
            }
        }
    }

}
