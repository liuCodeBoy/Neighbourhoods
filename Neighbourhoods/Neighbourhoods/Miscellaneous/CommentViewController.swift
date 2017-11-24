//
//  CommentViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarTitle(title: "写评论")
        
        let issueBtn = UIBarButtonItem(title: "发送", style: .done, target: self, action: #selector(issueBtnClicked))
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(pop))
        
        self.navigationItem.setLeftBarButton(backBtn, animated: true)
        self.navigationItem.setRightBarButton(issueBtn, animated: true)
    }

    
    @objc func issueBtnClicked() {
        
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
