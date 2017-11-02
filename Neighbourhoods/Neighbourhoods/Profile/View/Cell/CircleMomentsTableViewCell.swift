//
//  CircleMomentsTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class CircleMomentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var certifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var textLbl: UILabel!

    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var imageRight: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
