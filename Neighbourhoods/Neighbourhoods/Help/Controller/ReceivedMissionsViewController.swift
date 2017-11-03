//
//  ReceivedMissionsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 03/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ReceivedMissionsViewController: UIViewController {

    @IBOutlet weak var receivedMissionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receivedMissionTableView.delegate = self
        receivedMissionTableView.dataSource = self
    }
}

extension ReceivedMissionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReceivedMissionsCell")
        return cell!
    }
}
