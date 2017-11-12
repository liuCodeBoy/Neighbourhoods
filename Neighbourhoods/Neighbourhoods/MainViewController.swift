//
//  MainViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

var tabBarHeight: CGFloat {
    set {
        
    }
    get {
        if isIPHONEX {
            return 83
        } else {
            return 49
        }
    }
}

class MainViewController: UITabBarController {
    
    let presentedVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
    
    var spring: UIView?

    @objc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(shareButtonClicked), name: NSNotification.Name.init(shareNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueTopicsVC), name: NSNotification.Name.init(issueTopicsNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueMissionVC), name: NSNotification.Name.init(issueMissionNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showQuickMessageVC), name: NSNotification.Name.init(quickLookMessageNotification), object: nil)


    }
    
    @objc func addButtonClicked() {
        
        let presentedVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        let springView = Bundle.main.loadNibNamed("SpringView", owner: self, options: nil)?.first! as! UIView
        spring = springView
        springView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        presentedVC?.view.addSubview(springView)

    }
    
    @objc func shareButtonClicked() {
        
        let presentedVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        let springView = Bundle.main.loadNibNamed("Share", owner: self, options: nil)?.first! as! UIView
        spring = springView
        springView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        presentedVC?.view.addSubview(springView)
        
    }
    
    @objc func closeBtnClicked() {
        
        spring?.removeFromSuperview()
        
    }
    
    @objc func showIssueTopicsVC() {
        self.present(IssueTopicsViewController(), animated: true, completion: nil)
    }
    
    @objc func showIssueMissionVC() {
        self.present(IssueMissionViewController(), animated: true, completion: nil)
    }
    
    @objc func showQuickMessageVC() {
        self.present(UIStoryboard.init(name: "QuickViewMessgaes", bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}
