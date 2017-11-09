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
class MomentsCommentDetialSpecificCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    var momentsCellModel : NborCircleModel!{
        didSet {
            self.nickName.text = momentsCellModel.user?.nickname
            self.textLbl.text = momentsCellModel.content
            let userModel =  momentsCellModel.user
            if let avatarString  =  userModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
            }
            self.likeBtn.titleLabel?.text = "\(String(describing: momentsCellModel.love))"
            self.commentBtn.titleLabel?.text = "\(String(describing: momentsCellModel.comment))"
            if let timeNum = momentsCellModel.time {
                self.createTime.text = NSDate.createDateString(createAtStr: "\(timeNum)")
            }
            if  let repairDetail = momentsCellModel.info {
                commentCountLbl.text = repairDetail
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
    
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
