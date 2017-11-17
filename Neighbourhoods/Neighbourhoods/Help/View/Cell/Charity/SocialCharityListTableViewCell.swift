//
//  SocialCharityListTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SocialCharityListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var charityAvatr: UIImageView!
    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var charityLocation: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var viewModel: SocialOrgListModel? {
        didSet {
            if let name = viewModel?.name {
                charityName.text = name
            }
            if let content = viewModel?.content {
                charityLocation.text = content
            }
            if let avatarStr = viewModel?.head_pic {
                charityAvatr.sd_setImage(with: URL.init(string: avatarStr), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
        }
    }
}
