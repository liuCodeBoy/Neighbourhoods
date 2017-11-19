//
//  HelpCategoryByCompletionStatusTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 03/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class HelpCategoryByCompletionStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var scoreBtn: UIButton!
    
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var createTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var viewModel: TaskListModel? {
        didSet {
            if let title = viewModel?.title {
                titleLbl.text = title
            }
            if let content = viewModel?.content {
                detialLbl.text = content
            }
            if let status = viewModel?.task_status {
                switch status {
                case 0      : scoreBtn.setTitle("待领取", for: .normal)
                              marginView.backgroundColor = mission_going
                case 1, 2   : scoreBtn.setTitle("进行中", for: .normal)
                              marginView.backgroundColor = mission_going
                case 3, 4   : scoreBtn.setTitle("已完成", for: .normal)
                              marginView.backgroundColor = mission_complete
                default: break
                }
            }
            if let time = viewModel?.time {
                createTime.text = NSDate.createDateString(createAtStr: "\(String(describing: time))")
            }
        }
    }
    
}
