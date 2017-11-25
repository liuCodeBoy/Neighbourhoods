//
//  FigureVoteListTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class FigureVoteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var voteCountLbl: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var rankLbl: UILabel!
    var   model :  VoteOptionList?{
        didSet{
            if let  name = model?.user?.nickname {
                self.nickName.text = name
            }
            if let  sex = model?.user?.sex?.intValue {
              if sex == 1 || sex == 2 {
                self.gender.image =   sex == 1 ? UIImage.init(named: "male") : UIImage.init(named: "female")
             }
            }
            
            if let selected = model?.select?.intValue{
                if  selected == 0 {
                voteBtn.setTitle("投票", for: .normal)
                voteBtn.backgroundColor = default_orange
                }else if  selected == 1{
                voteBtn.setTitle("已投票", for: .normal)
                voteBtn.backgroundColor = default_grey
                }
            }
            if let avatarString  =  model?.user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
            }
            if let number = model?.number{
                if number == 0{
                    self.voteCountLbl.text = "快为他投上一票"
                }else{
                self.voteCountLbl.text = "已有\(number)人为他投票"
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
