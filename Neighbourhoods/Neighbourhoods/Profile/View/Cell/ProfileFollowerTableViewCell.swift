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
    
    var viewModel: AttentionAndFansModel? {
        didSet {
            if let avatatStr = viewModel?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatatStr), placeholderImage: #imageLiteral(resourceName: "notice_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.nickname {
                self.nickName.text = name
            }
            if let verify = viewModel?.type {
                self.verifyLbl.text = verify
            }
            if let gender = viewModel?.sex {
                if gender == 1 {
                    self.gender.image = #imageLiteral(resourceName: "male")
                } else if gender == 2  {
                    self.gender.image = #imageLiteral(resourceName: "female")
                }
            }
            
            // FIXME: - location bug
            //            if let location = viewModel? {
            //                self.locationBtn.setTitle(location, for: .normal)
            //            } else {
            //                self.locationBtn.isHidden = true
            //            }
            self.location.text = ""
            
            if let isFollowing = viewModel?.is_atten {
                if isFollowing == 1 {
                    alreadyFollowLbl.isHidden = false
                    addFollowView.isHidden    = true
                } else {
                    alreadyFollowLbl.isHidden = true
                    addFollowView.isHidden    = false
                }
            }
        }
    }
}
