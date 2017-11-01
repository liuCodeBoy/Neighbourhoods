//
//  QuickViewMessgaesViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class QuickViewMessgaesViewController: UIViewController {
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }

    @IBOutlet weak var contactListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        
    
    }


}

extension QuickViewMessgaesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ContactListUserCell")!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let top = UITableViewRowAction(style: .normal, title: "置顶") { (action, index) in
            print("top")
        }
        top.backgroundColor = following_top
        let delete = UITableViewRowAction(style: .normal, title: "删除") { (action, index) in
            print("delete")
        }
        delete.backgroundColor = following_delete
        
        return [delete, top]
    }
    
}
