//
//  SelfProfileViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SelfProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarTitle(title: "我的")
        
        let editBtn = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(editSelfProfile))
        self.navigationItem.setRightBarButton(editBtn, animated: true)
    }
    
    @objc func editSelfProfile() {
        
    }

}
