//
//  QuickMessageListTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class QuickMessageListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var messageAbbr: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: MsgListModel? {
        didSet {
            if let count = viewModel?.msg_count {
                self.msgCountLbl.isHidden = false
                self.msgCountLbl.text = "\(count)"
            }
            if let name = viewModel?.msg_user {
                self.nickName.text = name
            }
            if let content = viewModel?.content {
                self.messageAbbr.text = content
            }
            if let time = viewModel?.time {
                self.timeLbl.text = NSDate.createDateString(createAtStr: "\(time)")
            }
            if viewModel?.msg_count == 0 {
                self.nickName.text = "暂无消息"
                self.messageAbbr.text = ""
                self.timeLbl.text = ""
                self.msgCountLbl.isHidden = true
            }
        }
    }


}
