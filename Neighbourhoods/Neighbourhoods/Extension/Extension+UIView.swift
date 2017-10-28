//
//  Extension+UIView.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK:- set round rect of a UIView
    func setRoundRect(targets: [UIView]) {
        for target in targets {
            target.layer.cornerRadius = target.frame.height / 2
            target.layer.masksToBounds = true
        }
    }
    
    // MARK:- set nav bar title
    func setNavBarTitle(title navTitle: String) {
        let titleLbl = UILabel()
        titleLbl.text = navTitle
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        titleLbl.textColor = navAndTabBarTintColor
        self.navigationItem.titleView = titleLbl
    }
    
    func setNavBarBackBtn() {
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(popopop))
        self.navigationItem.setLeftBarButton(back, animated: true)
    }
    
    @objc func popopop() {
        self.navigationController?.popViewController(animated: true)
    }


}
