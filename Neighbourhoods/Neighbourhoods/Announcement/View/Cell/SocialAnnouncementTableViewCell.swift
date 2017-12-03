//
//  SocialAnnouncementTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class SocialAnnouncementTableViewCell: UITableViewCell {

    @IBOutlet weak var noticeImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: ActListModel? {
        didSet {
            if let title = viewModel?.title {
                titleLbl.text = title
            }
            if let content = viewModel?.time {
                detialLbl.text = NSDate.createDateString(createAtStr: "\(content)")
            }
            guard   viewModel?.picture?[0] != nil else {
                return
            }
            if let avatarString  = viewModel?.picture![0] {
            self.noticeImage.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "social_orgnazation"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
            }
        }
        

    }

    
}
