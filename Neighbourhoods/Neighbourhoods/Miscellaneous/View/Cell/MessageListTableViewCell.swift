//
//  MessageListTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MessageListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var messageAbbr: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgCountLbl: UILabel!
    
    var uid: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: MsgListModel? {
        didSet {
            if let avatar = viewModel?.from_user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let nickname = viewModel?.from_user?.nickname {
                self.nickName.text = nickname
            }
            if let uid = viewModel?.from_user?.uid {
                self.uid = uid as? Int
            }
            if let count = viewModel?.number {
                self.msgCountLbl.text = "\(count)"
            }
            if let content = viewModel?.content {
                self.messageAbbr.text = content
            }
            if let time = viewModel?.time {
                self.timeLbl.text = NSDate.createDateString(createAtStr: "\(time)")
            }
        }
    }

}
