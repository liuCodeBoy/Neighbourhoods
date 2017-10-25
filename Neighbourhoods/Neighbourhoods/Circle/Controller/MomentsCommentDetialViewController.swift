//
//  MomentsCommentDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MomentsCommentDetialViewController: UIViewController {

    @IBOutlet weak var momentsCommentDetialTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNavItems()
        
        momentsCommentDetialTableView.delegate = self
        momentsCommentDetialTableView.dataSource = self
        
        momentsCommentDetialTableView.register(UINib.init(nibName: "MomentDetialTableViewCell", bundle: nil), forCellReuseIdentifier: "MomentDetialCell")
        momentsCommentDetialTableView.register(UINib.init(nibName: "MomentDetialsCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "MomentDetialsCommentCell")

    }

    func loadNavItems() {
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: .done, target: self, action: #selector(pop))
        self.navigationItem.setLeftBarButton(backBtn, animated: true)
        self.setNavBarTitle(title: "圈内动态")
        
        let writeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_write_message"), style: .done, target: self, action: #selector(writeMessgae))
        let messgaeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_message"), style: .done, target: self, action: #selector(lookUpMessage))
        // MARK:- set right items
        self.navigationItem.setRightBarButtonItems([messgaeBtn, writeBtn], animated: true)
        
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func writeMessgae() {
        
        self.navigationController?.pushViewController(CommentViewController(), animated: true)
        
    }
    
    @objc func lookUpMessage() {
        
    }
}

extension MomentsCommentDetialViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 175
        } else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "MomentDetialCell")!
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "MomentDetialsCommentCell")!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12
        } else {
            return 0.00001
        }
    }
    
}
