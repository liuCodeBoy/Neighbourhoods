//
//  MyIssueViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 27/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyIssueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavItems()
        
    }

    
    func loadNavItems() {
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: .done, target: self, action: #selector(pop))
        self.navigationItem.setLeftBarButton(backBtn, animated: true)
        self.setNavBarTitle(title: "我的发布")
        
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
