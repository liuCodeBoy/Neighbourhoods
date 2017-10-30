//
//  SocialCharityViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SocialCharityViewController: UIViewController {

    @IBOutlet weak var socialCharityListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        socialCharityListTableView.delegate = self
        socialCharityListTableView.dataSource = self
        
        setNavBarTitle(title: "社会公益组织")
        setNavBarBackBtn()
        
    }

}

extension SocialCharityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialCharityListCell")
        
        return cell!
    }
    
}
