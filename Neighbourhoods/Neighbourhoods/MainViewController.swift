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
    
    
    var spring: SpringView?
    
    var rootVC: UIViewController?
    
    var addBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK:- provide the initial avatar
        userAvatar.image = #imageLiteral(resourceName: "profile_avatar_placeholder")
        
        // MARK:- cover the null tab bar item
        let coverView = UIView(frame: CGRect(x: screenWidth / 2 - 50, y: screenHeight - tabBarHeight, width: 100, height: 49))

        self.view.addSubview(coverView)

        // MARK:- add the middle tab bar item
        let add = UIButton(frame: CGRect(x: screenWidth / 2 - 30, y: screenHeight - tabBarHeight - 21, width: 60, height: 60))
        add.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
        
        add.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        add.adjustsImageWhenHighlighted = false
        
        addBtn = add
        
        self.view.addSubview(add)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeBtnClicked), name: NSNotification.Name.init(closeSpringViewNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueMomentsVC), name: NSNotification.Name.init(issueMomentsNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueTopicsVC), name: NSNotification.Name.init(issueTopicsNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showIssueMissionVC), name: NSNotification.Name.init(issueMissionNotification), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(showIssueSignVC), name: NSNotification.Name.init(signInMotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showQuickMessageVC), name: NSNotification.Name.init(quickLookMessageNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideAddBtn), name: NSNotification.Name.init(hideAddButtonNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAddBtn), name: NSNotification.Name.init(showAddButtonNotification), object: nil)

    }
    
    @objc func hideAddBtn() {
        addBtn?.alpha = 0
    }
    
    @objc func showAddBtn() {
        addBtn?.alpha = 1
    }
    
    @objc func addButtonClicked() {
        let presentationVC = UIApplication.shared.keyWindow?.rootViewController?.presentationController
        let springView = Bundle.main.loadNibNamed("SpringView", owner: self, options: nil)?.first! as! SpringView
        
        spring = springView
        msg_count()
        springView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        presentationVC?.presentedView?.addSubview(springView)
        springView.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0.01, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            springView.alpha = 1
        }, completion: nil)
    }
    
    func msg_count(){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        NetWorkTool.shareInstance.msg_count(access_token) { [weak self](result, error) in
            if result!["code"] as! String == "200" {
                let num = result!["result"] as! Int
                if num == 0{
                 self?.spring?.numberLab.isHidden = true
                }else{
                 self?.spring?.numberLab.text = "\(num)"
                }
//                self.presentHintMessage(hintMessgae: "您还未填写地址", completion: { (action) in
//                    self.navigationController?.popViewController(animated: true)
//                    return
//                })
                
            }
        }
    }
    @objc func closeBtnClicked() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.spring?.alpha = 0
        }) { (_) in
            self.spring?.removeFromSuperview()
        }
        
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
    @objc func showIssueSignVC(){
         self.present(SignInViewController(), animated: true, completion: nil)
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
