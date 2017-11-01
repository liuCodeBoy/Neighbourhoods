//
//  SocialAnnouncementTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let announcementDetialNotification = "com.NJQL.announcement"

class SocialAnnouncementTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "SocialAnnouncementTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialAnnouncementCell")
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SocialAnnouncementCell")!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init(announcementDetialNotification), object: nil)
        
    }


}
