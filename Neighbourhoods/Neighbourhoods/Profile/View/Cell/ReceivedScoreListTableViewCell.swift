//
//  ReceivedScoreListTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 15/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ReceivedScoreListTableViewCell: UITableViewCell {

    @IBOutlet weak var receiveWayLbl: UILabel!
    @IBOutlet weak var receiveTimeLbl: UILabel!
    @IBOutlet weak var increaseScoreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var viewModel: MyIntegralModel? {
        didSet {
            if let way = viewModel?.record {
                receiveWayLbl.text = way
            }
            if let increase = viewModel?.increase {
                increaseScoreLbl.text = "\(increase)"
            }
            if let time = viewModel?.time {
                receiveTimeLbl.text = NSDate.createDateString(createAtStr: "\(time)")
            }
        }
    }
}
