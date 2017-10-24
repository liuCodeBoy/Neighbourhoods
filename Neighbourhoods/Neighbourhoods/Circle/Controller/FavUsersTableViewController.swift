//
//  FavUsersTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 24/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class FavUsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(UINib(nibName: "aaa", bundle: nil), forCellReuseIdentifier: "aaa")
        

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aaa")

        return cell!

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}
