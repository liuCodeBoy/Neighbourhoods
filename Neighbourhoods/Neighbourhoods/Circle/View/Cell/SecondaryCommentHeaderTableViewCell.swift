//
//  SecondaryCommentHeaderTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class SecondaryCommentHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var certifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    var momentsCellModel : NborCircleModel!{
        didSet {
            let userModel =  momentsCellModel.user_info
            if let nickName = userModel?.nickname {
                self.nickName.text = nickName
            }
            if let  userType =  userModel?.type {
                self.certifyLbl.text = userType
            }
            if let avatarString  =  userModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
            }
            if let timeNum = momentsCellModel.time {
                self.createTime.text = NSDate.createDateString(createAtStr: "\(timeNum)")
            }
            
            let  sex = userModel?.sex?.intValue
            if sex == 1 || sex == 2 {
                self.gender.image =   sex == 1 ? UIImage.init(named: "male") : UIImage.init(named: "female")
            }else{
            }
            if let locationString = momentsCellModel.address{
               self.location.text = locationString
            }
            if let  content =  momentsCellModel.content {
                self.textLbl.text =  content
            }
        }
    }
    
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(shareNotification), object: nil)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
