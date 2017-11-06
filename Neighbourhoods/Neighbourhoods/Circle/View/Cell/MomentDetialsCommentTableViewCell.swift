//
//  MomentDetialsCommentTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MomentDetialsCommentTableViewCell: UITableViewCell {
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init(shareNotification), object: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
