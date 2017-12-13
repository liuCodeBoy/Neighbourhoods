//
//  ProtocalsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 03/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ProtocalsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarAttribute()
    }
    
    func setNavBarAttribute() {
        
        let titleLbl = UILabel()
        titleLbl.text = "用户协议"
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        titleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.titleView = titleLbl
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(popopop))
        self.navigationItem.setLeftBarButton(back, animated: true)
    }
    
}
