//
//  MyMissionsTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyMissionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deialLbl: UILabel!
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var scoreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    var viewModel: MyMissionModel? {
        didSet {
            if let title = viewModel?.title {
                titleLbl.text = title
            }
            if let detial = viewModel?.content {
                deialLbl.text = detial
            }
            if let score = viewModel?.integral {
                scoreBtn.setTitle("\(score)", for: .normal)
            }
//                    if let time = viewModel.content {
//                        <#statements#>
//                    }
        }
    }

}
