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
            if let code = viewModel?.code {
                self.inviteCodeLbl.text = code
            }
            if let status = viewModel?.status {
                if status == 1 {
                    invitationCodeBackImg.image = #imageLiteral(resourceName: "invitation_code")
                    inviteLbl.textColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    expireTimeLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    inviteCodeLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    invitationCodeBackImg.image = #imageLiteral(resourceName: "invitation_code_used")
                    inviteLbl.textColor     = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    expireTimeLbl.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    inviteCodeLbl.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                }
            }
        }
    }

}
