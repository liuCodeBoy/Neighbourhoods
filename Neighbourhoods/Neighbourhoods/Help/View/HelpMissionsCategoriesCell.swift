//
//  HelpMissionsCategoriesCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 20/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class HelpMissionsCategoriesCell: UITableViewCell {

    @IBOutlet weak var marginView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        marginView.layer.cornerRadius = 6
        marginView.layer.masksToBounds = true
    }

}
