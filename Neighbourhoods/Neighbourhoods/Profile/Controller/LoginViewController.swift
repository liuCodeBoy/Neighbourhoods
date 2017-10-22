//
//  LoginViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountBackView: UIView!
    @IBOutlet weak var pwdBackView: UIView!
    @IBOutlet weak var loginBtnBackView: UIButton!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    
    
    // MARK:- Passenger login
    @IBAction func passengerLoginClicked(_ sender: UIButton) {
        let mainVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
        self.present(mainVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRoundRect(targets: [accountBackView, pwdBackView, loginBtnBackView])
        
        setNavBarAttribute()
        
    }
    
    func setNavBarAttribute() {
        let titleLbl = UILabel()
        titleLbl.text = "登录注册"
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        titleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navBar.titleView = titleLbl
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = navAndTabBarTintColor
        
        
    }

}
