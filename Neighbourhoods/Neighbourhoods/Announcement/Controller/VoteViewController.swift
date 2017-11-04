//
//  ActivityVoteTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityVoteCell") as! ActivityVoteTableViewCell
        let figureCell = tableView.dequeueReusableCell(withIdentifier: "FigureVoteCell") as! FigureVoteTableViewCell

        switch indexPath.row {
        case 0:
            figureCell.statusBtn.setTitle("正在投票", for: .normal)
            figureCell.statusBtn.backgroundColor = defaultBlueColor
            return figureCell
        case 1:
            figureCell.statusBtn.setTitle("已结束", for: .normal)
            figureCell.statusBtn.backgroundColor = default_grey
            return figureCell
        case 2:
            activityCell.statusBtn.setTitle("协商中", for: .normal)
            activityCell.statusBtn.backgroundColor = default_orange
            return activityCell
        case 3:
            activityCell.statusBtn.setTitle("正在投票", for: .normal)
            activityCell.statusBtn.backgroundColor = defaultBlueColor
            return activityCell
        case 4:
            activityCell.statusBtn.setTitle("已结束", for: .normal)
            activityCell.statusBtn.backgroundColor = default_grey
            return activityCell
        default: break
        }

        return activityCell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityVoteConsultingVC") as! ActivityVoteConsultingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityVoteCounsultantCompletedVC") as! ActivityVoteCounsultantCompletedViewController
            self.navigationController?.pushViewController(vc, animated: true)

        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityVoteEndedVC") as! ActivityVoteEndedViewController
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    

}
