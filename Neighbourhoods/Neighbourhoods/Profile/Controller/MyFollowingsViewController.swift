//
//  MyFollowingsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyFollowingsViewController: UIViewController {

    @IBOutlet weak var myFollowingsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowingsTableView.delegate = self
        myFollowingsTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "我的关注")
        
    }


}

extension MyFollowingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFollowingsCell") as! ProfileFollowingTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }

}
