//
//  MainViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK:- cover the null tab bar item
        let coverView = UIView(frame: CGRect(x: screenWidth / 2 - 50, y: screenHeight - 49, width: 100, height: 49))
        self.view.addSubview(coverView)

        // MARK:- add the middle tab bar item
        let add = UIButton(frame: CGRect(x: screenWidth / 2 - 30, y: screenHeight - 70, width: 60, height: 60))
        add.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
        
        add.adjustsImageWhenHighlighted = false
        
        self.view.addSubview(add)
    }


}
