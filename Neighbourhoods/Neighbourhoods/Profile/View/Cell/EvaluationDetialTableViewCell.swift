//
//  EvaluationDetialTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 12/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class EvaluationDetialTableViewCell: UITableViewCell {
    
    var pushImageClouse : pushImageType?
    
    @IBOutlet weak var evaAvatar: UIImageView!
    @IBOutlet weak var evaNickNameLbl: UILabel!
    
    @IBOutlet weak var evaStarCountImg: UIImageView!
    @IBOutlet weak var evaTimeLbl: UILabel!
    @IBOutlet weak var evaDetialLbl: UILabel!
    @IBOutlet weak var evaImage: UIImageView!
    @IBOutlet weak var evaImgHCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    var viewModel: EvaluationDetModel? {
        didSet {
            if let avatar = viewModel?.head_pic {
                self.evaAvatar.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let nickname = viewModel?.user {
                self.evaNickNameLbl.text = nickname
            }
            if let starCount = viewModel?.star {
                switch starCount as! Int {
                case 1: evaStarCountImg.image = #imageLiteral(resourceName: "evaluate_one")
                case 2: evaStarCountImg.image = #imageLiteral(resourceName: "evaluate_two")
                case 3: evaStarCountImg.image = #imageLiteral(resourceName: "evaluate_three")
                case 4: evaStarCountImg.image = #imageLiteral(resourceName: "evaluate_four")
                case 5: evaStarCountImg.image = #imageLiteral(resourceName: "evaluate_five")
                default: evaStarCountImg.image = #imageLiteral(resourceName: "evaluate_none")
                }
            }
            if let time = viewModel?.time {
                self.evaTimeLbl.text = NSDate.createDateString(createAtStr: "\(time)")
            }
            if let content = viewModel?.content {
                self.evaDetialLbl.text = content
            }
            if let image = viewModel?.picture {
                self.evaImage.sd_setImage(with: URL.init(string: image), placeholderImage: #imageLiteral(resourceName: "img_loading_placeholder"), options: .continueInBackground, completed: nil)
                let tap = UITapGestureRecognizer.init(target: self, action:#selector(showImageVC))
                self.evaImage.addGestureRecognizer(tap)
            } else {
                self.evaImgHCons.constant = 0
            }
        }
    }
    
    @objc private func showImageVC() {
        let imgArray = [viewModel?.picture]
        if self.pushImageClouse != nil{
            self.pushImageClouse!(imgArray as NSArray ,0)
        }
    }


}
