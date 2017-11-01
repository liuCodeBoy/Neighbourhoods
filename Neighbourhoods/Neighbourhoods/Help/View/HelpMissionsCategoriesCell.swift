//
//  HelpMissionsCategoriesCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 20/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class HelpMissionsCategoriesCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var createTime: UILabel!
    

    @IBOutlet weak var marginView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        marginView.layer.cornerRadius = 6
        marginView.layer.masksToBounds = true
    }

}
