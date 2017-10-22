//
//  RegisterViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var pwdBackView: UIView!
    @IBOutlet weak var confirmBackView: UIView!
    @IBOutlet weak var sendIDNumBackVIew: UIButton!
    @IBOutlet weak var registerBackView: UIButton!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRoundRect(targets: [phoneBackView, pwdBackView, confirmBackView, sendIDNumBackVIew, registerBackView])
        
        // MARK:- set nav bar attribute
        setNavBarAttribute()
    }
    
    func setNavBarAttribute() {

        let titleLbl = UILabel()
        titleLbl.text = "注册"
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        titleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navBar.titleView = titleLbl
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(pop))
        self.navBar.setLeftBarButton(back, animated: true)
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

}
