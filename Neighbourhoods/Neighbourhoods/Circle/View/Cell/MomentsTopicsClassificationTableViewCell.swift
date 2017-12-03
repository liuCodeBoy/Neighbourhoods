//
//  MomentsTopicsClassificationTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class MomentsTopicsClassificationTableViewCell: UITableViewCell {

    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var topicTitleLbl: UILabel!
    @IBOutlet weak var topicDetialLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var readCountLbl: UILabel!
    var  cellModel : NborTopicModel?{
        didSet {
            if let toplabel = cellModel?.name{
                self.topicTitleLbl.text = "#" + (toplabel) + "#"
                self.topicTitleLbl.textColor = defaultBlueColor
            }
            self.topicDetialLbl.text =  cellModel?.content
            if let avatarString  =  cellModel?.picture {
            self.topicImage.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
            }
            if let comment = cellModel?.comment {
                self.commentCountLbl.text = "\(String(describing: comment))条评论"
            }
            if let browse_history = cellModel?.browse_history {
                self.readCountLbl.text  = "\(String(describing: browse_history))阅读"
            }
          }
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
