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
class CircleVCTopicsTableViewCell: UITableViewCell{
    var   pushImageClouse : pushImageType?
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
                    imageLeft.addGestureRecognizer(tapSecond)
                    let rightImage = pictureStringArr[1]
                    self.imageRight.sd_setImage(with: URL.init(string: rightImage as! String), completed: nil)

                }
            }else{
                imageHeightConstraint.constant = 0
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
    @IBAction func commentBtnCell(_ sender: UIButton) {
    }
    @objc func showImageVC(){
        if let pictureStringArr = momentsCellModel.picture{
        if self.pushImageClouse != nil{
            self.pushImageClouse!(pictureStringArr ,0)
            }
        }
    }
    @objc func showSecondVC(){
        if let pictureStringArr = momentsCellModel.picture{
            if self.pushImageClouse != nil{
                self.pushImageClouse!(pictureStringArr ,1)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageHeightConstraint.constant = 0
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
