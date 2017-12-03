//
//  ChattingWithTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 26/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

var userAvatar = UIImageView()

class ChattingWithTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var chatBackView: UIImageView!
    
    @IBOutlet weak var textMaxCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isIPHONE_SE {
            textMaxCons.constant = 175
        } else if isIPHONE_8 || isIPHONEX {
            textMaxCons.constant = 200
        } else if isIPHONE_8Plus {
            textMaxCons.constant = 240
        }
    }
    
    var viewModel: MsgHistoryModel? {
        didSet {
            if let avatar = viewModel?.from_user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let avatar = viewModel?.user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let content = viewModel?.content {
                self.contentLbl.text = content
            }
        }
    }


}
