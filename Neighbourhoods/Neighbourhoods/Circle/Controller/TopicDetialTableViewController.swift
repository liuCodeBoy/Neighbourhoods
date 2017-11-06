//
//  TopicDetialTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 05/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class TopicDetialTableViewController: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var topicDetialTextView: UITextView!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var readCountLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicDetialCell")
        return cell!
    }


}
