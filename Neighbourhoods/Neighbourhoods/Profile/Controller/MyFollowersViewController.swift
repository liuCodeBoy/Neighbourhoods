//
//  MyFollowersViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyFollowersViewController: UIViewController {
    
    @IBOutlet weak var myFollowersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myFollowersTableView.delegate = self
        myFollowersTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "我的粉丝")
    }


}

extension MyFollowersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFollowersCell") as! ProfileFollowerTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
}
