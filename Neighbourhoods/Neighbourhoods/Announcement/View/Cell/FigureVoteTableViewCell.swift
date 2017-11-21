//
//  FigureVoteTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let figureVoteListNotification = "com.NJQL.Announcement.FigureVote"

class FigureVoteTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    var modle : VoteListModel? {
        didSet{
            self.titleLbl.text  = modle?.title
            self.detialLbl.text = modle?.content
            if modle?.status == -1 {
                statusBtn.backgroundColor = default_grey
                statusBtn.setTitle("已结束", for: .normal)
            }else if  modle?.status == 1{
                statusBtn.backgroundColor = default_orange
                statusBtn.setTitle("协商中", for: .normal)
            }else if modle?.status == 2{
                statusBtn.backgroundColor = defaultBlueColor
                statusBtn.setTitle("正在投票", for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
}
