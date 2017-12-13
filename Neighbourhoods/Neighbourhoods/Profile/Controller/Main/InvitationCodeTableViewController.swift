//
//  InvitationCodeTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 13/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class InvitationCodeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        setNavBarTitle(title: "我的邀请码")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationCodeCell") as! InvitationCodeTableViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
