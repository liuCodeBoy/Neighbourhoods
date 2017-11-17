//
//  MyReceivedMissionTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 13/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyReceivedMissionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var statusBackView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: MyMissionModel? {
        didSet {
            if let title = viewModel?.title {
                titleLbl.text = title
            }
            if let detial = viewModel?.content {
                detialLbl.text = detial
            }
            if let status = viewModel?.task_status {
                switch status {
                case 1: statusBtn.setTitle("进行中", for: .normal)
                statusBackView.backgroundColor = mission_going
                case 2: statusBtn.setTitle("待完成", for: .normal)
                statusBackView.backgroundColor = mission_going
                case 3: statusBtn.setTitle("已完成", for: .normal)
                statusBackView.backgroundColor = mission_complete
                case 4: statusBtn.setTitle("被驳回", for: .normal)
                statusBackView.backgroundColor = mission_refuse
                default: break
                }
            }
            
        }
        
    }

}
