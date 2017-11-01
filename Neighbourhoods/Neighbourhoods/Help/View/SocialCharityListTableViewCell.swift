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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}