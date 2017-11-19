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
            if let btnTitle = viewModel?.task_status {
                scoreBtn.setTitle(" " + btnTitle, for: .normal)
            }
            if let time = viewModel?.time {
                createTime.text = NSDate.createDateString(createAtStr: "\(String(describing: time))")
            }
        }
    }
    
}
