//
//  ProfileFollowTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 09/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ProfileFollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
