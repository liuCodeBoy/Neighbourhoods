//
//  CircleMomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class CircleMomentsViewController: UIViewController {
    
    @IBOutlet weak var circleMomentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        circleMomentsTableView.delegate = self
        circleMomentsTableView.dataSource = self

        setNavBarTitle(title: "圈动态")
        setNavBarBackBtn()
    
    }


}

extension CircleMomentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "CircleMomentsCell")!
    }
}
