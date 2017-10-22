//
//  HelpViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 20/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var missionCategoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavBarItems()
        
        missionCategoriesTableView.delegate = self
        missionCategoriesTableView.dataSource = self
        
    }
    
    // MARK:- set nav attribute and items
    func loadNavBarItems() {
        let titleLbl = UILabel()
        titleLbl.textColor = defaultBlueColor
        titleLbl.text = "邻里帮"
        self.navigationItem.titleView = titleLbl
        
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_search"), style: .done, target: self, action: #selector(navSearch))
        let rightBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_write_message"), style: .done, target: self, action: #selector(navWriteMsg))
        self.navigationItem.setLeftBarButton(leftBtn, animated: true)
        self.navigationItem.setRightBarButton(rightBtn, animated: true)
        
    }

}

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpMissionCell")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK:- Nav Item functions
extension HelpViewController {
    
    @objc func navSearch() {
        
    }
    
    @objc func navWriteMsg() {
        
    }
}
