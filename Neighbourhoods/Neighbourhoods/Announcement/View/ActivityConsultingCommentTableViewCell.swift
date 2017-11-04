//
//  ActivityConsultingCommentTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ActivityConsultingCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var commentTextLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    
    @IBAction func subComment(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    }


}
