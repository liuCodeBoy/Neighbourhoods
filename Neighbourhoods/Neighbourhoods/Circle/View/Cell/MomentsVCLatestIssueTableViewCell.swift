//
//  MomentsVCLatestIssueTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class MomentsVCLatestIssueTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var nickName: UILabel!
    @IBOutlet private weak var certifyLbl: UILabel!
    @IBOutlet private weak var gender: UIImageView!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var createTime: UILabel!
    @IBOutlet private weak var textLbl: UILabel!
    @IBOutlet private weak var likeBtn: UIButton!
    @IBOutlet private weak var commentBtn: UIButton!
    @IBOutlet private weak var imageLeft: UIImageView!
    @IBOutlet private weak var imageRight: UIImageView!
    var momentsCellModel : NborCircleModel!{
        didSet {
            self.nickName.text = momentsCellModel.user?.nickname
            self.imageLeft.isHidden = true
            self.imageRight.isHidden = true
//        if let pictureString = momentsCellModel.picture{
//            self.avatar.sd_setImage(with: URL.init(string: pictureString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
//            }
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

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
