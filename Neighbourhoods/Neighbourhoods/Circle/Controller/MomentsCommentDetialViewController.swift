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

        setNavBarBackBtn()
        setNavBarTitle(title: "圈内动态")
        
        momentsCommentDetialTableView.delegate = self
        momentsCommentDetialTableView.dataSource = self

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
            return tableView.dequeueReusableCell(withIdentifier: "MomentsCommentDetialHeaderCell")!
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "MomentsCommentDetialSpecificCommentCell")!
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
