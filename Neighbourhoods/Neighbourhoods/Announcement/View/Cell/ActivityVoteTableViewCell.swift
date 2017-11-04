//
//  ActivityVoteTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let activityVoteListNotification = "com.NJQL.Announcement.ActivityVote"

class ActivityVoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
}
