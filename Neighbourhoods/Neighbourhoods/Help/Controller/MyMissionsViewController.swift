//
//  MyMissionsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyMissionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavItems()
    }
    
    func loadNavItems() {
        self.setNavBarBackBtn()
        self.setNavBarTitle(title: "我的任务")
        
        let writeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_write_message"), style: .done, target: self, action: #selector(writeMessgae))
        let messgaeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_message"), style: .done, target: self, action: #selector(lookUpMessage))
        // MARK:- set right items
        self.navigationItem.setRightBarButtonItems([messgaeBtn, writeBtn], animated: true)
        
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func writeMessgae() {
        
    }
    
    @objc func lookUpMessage() {
        
    }


}
