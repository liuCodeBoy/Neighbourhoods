//
//  CircleViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 14/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    @IBOutlet weak var topicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topicsTableView.delegate = self
        topicsTableView.dataSource = self

    }

}

extension CircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotTopicsCell")
        return cell!
    }
    
}
