//
//  LotteryTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class LotteryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    var lotterModel : LotteryListModel? {
    didSet{
         if let title = lotterModel?.title {
         titleLab.text = title
            }
        if let status = lotterModel?.status {
            if status == -1 {
                self.statusBtn.setTitle("已结束", for: .normal)
            }else if status == 1{
                self.statusBtn.setTitle("即将开始", for: .normal)
            }else if status == 2{
                self.statusBtn.setTitle("进行中", for: .normal)
            }
         }
        if let timeNum = lotterModel?.time {
            self.timeLab.text = NSDate.createDateString(createAtStr: "\(timeNum)")
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
