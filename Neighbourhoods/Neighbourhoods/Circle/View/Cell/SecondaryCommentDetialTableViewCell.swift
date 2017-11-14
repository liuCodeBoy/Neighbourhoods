//
//  SecondaryCommentDetialTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
typealias MonentSecondaryCommentHeadImageType = (NSNumber?) -> ()
class SecondaryCommentDetialTableViewCell: UITableViewCell {
    var  headImagePushClouse   : MonentSecondaryCommentHeadImageType?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    var momentsCellModel : NborCircleModel!{
        didSet {
            let userModel =  momentsCellModel.user_info
            if let nickName = userModel?.nickname {
                self.nickName.text = nickName
            }
            if let avatarString  =  userModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                let  headImageTap = UITapGestureRecognizer.init(target: self,action:#selector(showUserInfoVC))
                self.avatar.addGestureRecognizer(headImageTap)
            }
            if let timeNum = momentsCellModel.time {
                self.createTime.text = NSDate.createDateString(createAtStr: "\(timeNum)")
            }
            if let  content =  momentsCellModel.content {
                self.textLbl.text =  content
            }
        }
    }
    @IBAction func likeBtnClicked(_ sender: UIButton) {
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
