//
//  ActivityUnderVotingCell.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/23.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

class ActivityUnderVotingCell: UITableViewCell {

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var VoteBtn: UIButton!
    var   model : VoteOptionList?{
        didSet{
         self.nameText.text = model?.name
        if let selected = model?.select?.intValue{
            if  selected == 0 {
            VoteBtn.setTitle("投票", for: .normal)
            VoteBtn.backgroundColor = default_orange
            }else if  selected == 1{
            VoteBtn.setTitle("已投票", for: .normal)
            VoteBtn.backgroundColor = default_grey
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    @IBAction func VoteAction(_ sender: Any) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
