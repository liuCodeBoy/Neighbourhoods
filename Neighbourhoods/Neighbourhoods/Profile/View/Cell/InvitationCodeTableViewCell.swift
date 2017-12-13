//
//  InvitationCodeTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 13/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class InvitationCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var invitationCodeBackImg: UIImageView!
    @IBOutlet weak var inviteLbl: UILabel!
    @IBOutlet weak var expireTimeLbl: UILabel!
    @IBOutlet weak var inviteCodeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var viewModel: InvitationCodeModel? {
        didSet {
            
        }
    }

}
