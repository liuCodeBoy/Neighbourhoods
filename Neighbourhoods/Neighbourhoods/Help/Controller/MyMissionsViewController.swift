//
//  MyMissionsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MyMissionsViewController: UIViewController {
    
    @IBOutlet weak var myIssueMissionBtn: UIButton!
    @IBOutlet weak var receivedMissionBtn: UIButton!
    
    @IBAction func btn1Clicked(_ sender: UIButton) {
        myIssueMissionBtn.isSelected = true
        receivedMissionBtn.isSelected = false
    }
    @IBAction func btn2Clicked(_ sender: UIButton) {
        myIssueMissionBtn.isSelected = false
        receivedMissionBtn.isSelected = true
    }
    
    @IBOutlet weak var missionsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavItems()
        missionsTableView.delegate = self
        missionsTableView.dataSource = self
    }
    
    func loadNavItems() {
        self.setNavBarBackBtn()
        self.setNavBarTitle(title: "我的任务")
        
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }


}


extension MyMissionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMissionsCell")
        return cell!
    }
}
