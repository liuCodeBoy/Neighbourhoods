//
//  ShowVoteActCell.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/23.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

class ShowVoteActCell: UITableViewCell {
    @IBOutlet weak var Chosewidth: NSLayoutConstraint!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var percentageText: UILabel!
    var  model : VoteResultModel?{
        didSet{
            if let selected = model?.select{
                if selected == 1{
                 self.statusText.text =  "已选择"
                }else{
                 self.statusText.text =  ""
                }
            }
            if let name = model?.name{
                self.nameText.text = name
            }
            if let percentage = model?.percentage{
                self.percentageText.text = "\(percentage)%"
                self.Chosewidth.constant  += (screenWidth - 60) * (CGFloat(truncating: percentage) / 100)
            }
            
          
           
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
