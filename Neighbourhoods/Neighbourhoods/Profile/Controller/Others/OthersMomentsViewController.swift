//
//  OthersMomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class OthersMomentsViewController: UIViewController {

    @IBOutlet weak var othersMomentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        othersMomentsTableView.delegate = self
        othersMomentsTableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "他的")

    }


}

extension OthersMomentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "OthersMomentsCell")!
    }
}
