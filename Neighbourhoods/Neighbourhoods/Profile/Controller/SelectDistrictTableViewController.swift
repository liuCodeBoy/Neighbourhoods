//
//  SelectDistrictTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SelectDistrictTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "当前小区")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistrictNameCell")
        
        switch indexPath.row {
        case 0: cell?.textLabel?.text = "111"
        case 1: cell?.textLabel?.text = "222"
        case 2: cell?.textLabel?.text = "333"
        case 3: cell?.textLabel?.text = "444"
        case 4: cell?.textLabel?.text = "555"
        case 5: cell?.textLabel?.text = "666"
        default: cell?.textLabel?.text = "777"

        }
        
        return cell!
    }

    
}
