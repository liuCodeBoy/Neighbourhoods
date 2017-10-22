//
//  MyScoreVC.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyScoreVC: UIViewController {
    
    @IBOutlet weak var receiveScoreTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receiveScoreTableView.delegate = self
        receiveScoreTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3019607961, green: 0.6941176653, blue: 0.980392158, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false

       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 0.98)
    }

}

extension MyScoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveScoreCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
