//
//  CommentQucikViewListTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class CommentQucikViewListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fromUserLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detial: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var viewModel: MsgListModel? {
        didSet {
            if let avatar = viewModel?.from_user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let from = viewModel?.from_user?.nickname {
                self.fromUserLbl.text = from
            }
            if let image = viewModel?.picture?.first {
                self.img.sd_setImage(with: URL.init(string: image), placeholderImage: #imageLiteral(resourceName: "img_loading_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let title = viewModel?.user {
                self.title.text = title
            }
            if let detial = viewModel?.content {
                self.detial.text = detial
            }
            if let time = viewModel?.time {
                self.timeLbl.text = NSDate.createDateString(createAtStr: "\(time)")
            }
        }
    }

}
