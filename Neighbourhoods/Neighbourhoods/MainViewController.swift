//
//  MainViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    let presentedVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
    
    var spring: UIView?

    @objc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tabBarHeight: CGFloat = 0
        
        if isIPHONEX {
            tabBarHeight = 83
        } else {
            tabBarHeight = 49
        }
        // MARK:- cover the null tab bar item
        let coverView = UIView(frame: CGRect(x: screenWidth / 2 - 50, y: screenHeight - tabBarHeight, width: 100, height: 49))

        self.view.addSubview(coverView)

        // MARK:- add the middle tab bar item
        let add = UIButton(frame: CGRect(x: screenWidth / 2 - 30, y: screenHeight - tabBarHeight - 21, width: 60, height: 60))
        add.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
        
        add.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        add.adjustsImageWhenHighlighted = false
        
        self.view.addSubview(add)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeBtnClicked), name: NSNotification.Name.init(closeSpringViewNotification), object: nil)
    }
    
    @objc func addButtonClicked() {
        
        let presentedVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        let springView = Bundle.main.loadNibNamed("SpringView", owner: self, options: nil)?.first! as! UIView
        spring = springView
        springView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        presentedVC?.view.addSubview(springView)


    }
    
    @objc func closeBtnClicked() {
        
        spring?.removeFromSuperview()
        

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}
