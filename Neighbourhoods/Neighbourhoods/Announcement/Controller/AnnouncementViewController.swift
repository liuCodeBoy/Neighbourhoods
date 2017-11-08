//
//  AnnouncementViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 30/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {
    
    @IBOutlet weak var socialAnnouncement: UIButton!
    @IBOutlet weak var lottery: UIButton!
    @IBOutlet weak var vote: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    var announcementView: UIView?
    var lotteryView: UIView?
    var voteView: UIView?
    
    @IBAction func btn1Clicked(_ sender: UIButton) {
        socialAnnouncement.isSelected   = true
        lottery.isSelected              = false
        vote.isSelected                 = false
        
        announcementView?.isHidden      = false
        lotteryView?.isHidden           = true
        voteView?.isHidden              = true
    }
    @IBAction func btn2Clicked(_ sender: UIButton) {
        socialAnnouncement.isSelected   = false
        lottery.isSelected              = true
        vote.isSelected                 = false
        
        announcementView?.isHidden      = true
        lotteryView?.isHidden           = false
        voteView?.isHidden              = true
    }
    @IBAction func btn3Clicked(_ sender: UIButton) {
        socialAnnouncement.isSelected   = false
        lottery.isSelected              = false
        vote.isSelected                 = true
        
        announcementView?.isHidden      = true
        lotteryView?.isHidden           = true
        voteView?.isHidden              = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarTitle(title: "社区公告")
        
        loadTableViews()

       
    }
    
    func loadTableViews() {
        let childVC1 = self.storyboard?.instantiateViewController(withIdentifier: "SocialAnnouncementVC") as! SocialAnnouncementViewController
        let childVC2 = self.storyboard?.instantiateViewController(withIdentifier: "LotteryVC") as! LotteryViewController
        let childVC3 = self.storyboard?.instantiateViewController(withIdentifier: "VoteVC") as! VoteViewController
        
        announcementView = childVC1.view
        lotteryView = childVC2.view
        voteView = childVC3.view
        
        let y = lineView.frame.origin.y + 1
        
        announcementView?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)
        lotteryView?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)
        voteView?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)

        
        self.addChildViewController(childVC1)
        self.addChildViewController(childVC2)
        self.addChildViewController(childVC3)

        self.view.addSubview(lotteryView!)
        self.view.addSubview(voteView!)
        self.view.addSubview(announcementView!)
    }


}


