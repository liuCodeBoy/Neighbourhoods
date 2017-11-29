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
    
    
    var spring: UIView?
    
    var rootVC: UIViewController?
    
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
                
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueMomentsVC), name: NSNotification.Name.init(issueMomentsNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueTopicsVC), name: NSNotification.Name.init(issueTopicsNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueMissionVC), name: NSNotification.Name.init(issueMissionNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showQuickMessageVC), name: NSNotification.Name.init(quickLookMessageNotification), object: nil)


    }
    
    @objc func addButtonClicked() {
        let presentationVC = UIApplication.shared.keyWindow?.rootViewController?.presentationController
        
        let springView = Bundle.main.loadNibNamed("SpringView", owner: self, options: nil)?.first! as! UIView
        spring = springView
        springView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        presentationVC?.presentedView?.addSubview(springView)
        springView.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0.01, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            springView.alpha = 1
        }, completion: nil)
    }

    
    @objc func showIssueMomentsVC() {
        self.present(IssueMomentsViewController(), animated: true, completion: nil)

    }
    @objc func showIssueTopicsVC() {
        self.present(IssueTopicsViewController(), animated: true, completion: nil)
    }
    
    @objc func showIssueMissionVC() {
        self.present(IssueMissionViewController(), animated: true, completion: nil)
    }
    
    @objc func showQuickMessageVC() {
        let vc = UIStoryboard.init(name: "QuickViewMessgaes", bundle: nil).instantiateInitialViewController()! as! QuickViewMessgaesViewController
        self.rootVC = vc
        let nav = UINavigationController(rootViewController: vc)
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(dismissRootVC))
        vc.navigationItem.setLeftBarButton(back, animated: true)
        vc.setNavBarTitle(title: "消息")
        self.present(nav, animated: true, completion: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissRootVC() {
        self.rootVC?.dismiss(animated: true, completion: nil)
    }


}
