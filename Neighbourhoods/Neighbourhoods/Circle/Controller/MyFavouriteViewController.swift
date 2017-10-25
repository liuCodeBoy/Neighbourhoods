//
//  MyFavouriteViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 24/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyFavouriteViewController: UIViewController {
    
    @IBOutlet weak var myFavTableView: UITableView!
    
    @IBOutlet weak var favMoments: UIButton!
    @IBOutlet weak var favUsers: UIButton!
    
    var favUserTableView: UIView?
    
    @IBAction func btn1clicked(_ sender: UIButton) {
        
        // MARK:- change button control state
        favMoments.isSelected = true
        favUsers.isSelected = false
        
        // MARK:- hide the user list table view
        favUserTableView?.isHidden = true
        
    }
    
    @IBAction func btn2clicked(_ sender: UIButton) {
        favMoments.isSelected = false
        favUsers.isSelected = true
        
        // MARK:- reveal the user list table view
        favUserTableView?.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNavItems()
        myFavTableView.delegate = self
        myFavTableView.dataSource = self
        
        loadFavUserVC()
        favUserTableView?.isHidden = true
        
    }
    
    
    // MARK:- initialize the user list table view and controller
    func loadFavUserVC() {
        
        let childVC = FavUsersTableViewController()
        
        let tableView = childVC.view
        favUserTableView = tableView
        
        let y = (favMoments.superview?.frame.maxY)! + 1
        
        tableView?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y - 49)
        
        self.addChildViewController(childVC)
        self.view.addSubview(tableView!)
        
    }
    
    func loadNavItems() {
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: .done, target: self, action: #selector(pop))
        self.navigationItem.setLeftBarButton(backBtn, animated: true)
        self.setNavBarTitle(title: "圈内动态")
        
        let writeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_write_message"), style: .done, target: self, action: #selector(writeMessgae))
        let messgaeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_message"), style: .done, target: self, action: #selector(lookUpMessage))
        // MARK:- set right items
        self.navigationItem.setRightBarButtonItems([messgaeBtn, writeBtn], animated: true)
        
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func writeMessgae() {
        
        self.navigationController?.pushViewController(CommentViewController(), animated: true)
        
    }
    
    @objc func lookUpMessage() {
        
    }


}


extension MyFavouriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavouriteCell")
        return cell!
    }
}
