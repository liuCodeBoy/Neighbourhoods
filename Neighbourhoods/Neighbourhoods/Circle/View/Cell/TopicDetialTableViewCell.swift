//
//  TopicDetialTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
import NoticeBar
typealias MonentDetailHeadImageType = (NSNumber?) -> ()
typealias MonentDetialImageType = (NSArray? , NSNumber?) -> ()
class TopicDetialTableViewCell: UITableViewCell {
    var  headImagePushClouse   : MonentDetailHeadImageType?
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
        let  nbor_id  =  self.TopicDetialModel.id
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
                self?.likeBtn.setTitle("\(Int(truncating: (self?.TopicDetialModel.love!)!) + 1)", for: .normal)
            }
        }
    }
    @IBAction func commentBtnCell(_ sender: UIButton) {
    }
    var TopicDetialModel : NborCircleModel!{
        didSet {
            if let avatarString  =  TopicDetialModel?.user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                let  headImageTap = UITapGestureRecognizer.init(target: self, action:#selector(showUserInfoVC))
                avatar.addGestureRecognizer(headImageTap)
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
                self.likeBtn.setTitle("\(likeNum)", for: .normal)
            }
            if let  comment = TopicDetialModel.comment{
                self.commentBtn.setTitle("\(comment)", for: .normal)
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
    //点击头像
    @objc private func showUserInfoVC(){
        if let  otherID = self.TopicDetialModel.uid {
            if self.headImagePushClouse != nil {
                self.headImagePushClouse!(otherID)
            }
        }
    }

}
