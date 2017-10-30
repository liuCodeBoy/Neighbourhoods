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
    @IBOutlet weak var announcementTableView: UITableView!
    
    @IBAction func btn1Clicked(_ sender: UIButton) {
        socialAnnouncement.isSelected   = true
        lottery.isSelected              = false
        vote.isSelected                 = false
    }
    @IBAction func btn2Clicked(_ sender: UIButton) {
        socialAnnouncement.isSelected   = false
        lottery.isSelected              = true
        vote.isSelected                 = false
    }
    @IBAction func btn3Clicked(_ sender: UIButton) {
        socialAnnouncement.isSelected   = false
        lottery.isSelected              = false
        vote.isSelected                 = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarTitle(title: "社区公告")
        
//        announcementTableView.delegate = self
//        announcementTableView.dataSource = self
        
    }


}
//
//extension AnnouncementViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return nil
//    }
//}

