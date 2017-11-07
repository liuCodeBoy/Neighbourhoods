//
//  SocialAnnouncementTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SocialAnnouncementTableViewCell: UITableViewCell {

    @IBOutlet weak var noticeImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var readCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: ActListModel? {
        didSet {
            if let title = viewModel?.title {
                titleLbl.text = title
            }
            if let content = viewModel?.content {
                detialLbl.text = content
            }
//            if let comment = <#optional#> {
//                <#statements#>
//            }
        }
       
    }

    
}
