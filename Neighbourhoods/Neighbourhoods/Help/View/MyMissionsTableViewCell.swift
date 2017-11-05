//
//  MyMissionsTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyMissionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deialLbl: UILabel!
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var createTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
        marginView.layer.cornerRadius = 6
        marginView.layer.masksToBounds = true
        
    }


}
