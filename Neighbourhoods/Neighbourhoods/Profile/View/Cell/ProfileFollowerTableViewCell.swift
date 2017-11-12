//
//  ProfileFollowerTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 10/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ProfileFollowerTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var alreadyFollowLbl: UILabel!
    @IBOutlet weak var addFollowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cancelGes = UITapGestureRecognizer(target: self, action: #selector(cancelFollow))
        alreadyFollowLbl.addGestureRecognizer(cancelGes)
        
        let addFollowGes = UITapGestureRecognizer(target: self, action: #selector(addFollow))
        addFollowView.addGestureRecognizer(addFollowGes)
        
    }
    
    @objc func addFollow() {
        alreadyFollowLbl.isHidden = false
        addFollowView.isHidden    = true
    }
    
    @objc func cancelFollow() {
        alreadyFollowLbl.isHidden = true
        addFollowView.isHidden    = false
        
    }
    
}
