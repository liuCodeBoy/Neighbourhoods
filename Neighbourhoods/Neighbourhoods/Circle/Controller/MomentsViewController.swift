//
//  MomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController {
    
    @IBOutlet weak var latestIssue: UIButton!
    @IBOutlet weak var hotestTopic: UIButton!
    @IBOutlet weak var topicClassify: UIButton!
    
    @IBOutlet weak var topicsView: UIView!
    
    @IBAction func btn1clicked(_ sender: UIButton) {
        latestIssue.isSelected = true
        hotestTopic.isSelected = false
        topicClassify.isSelected = false
        
        topicsView.isHidden = true
    }
    @IBAction func btn2clicked(_ sender: UIButton) {
        latestIssue.isSelected = false
        hotestTopic.isSelected = true
        topicClassify.isSelected = false
        
        topicsView.isHidden = true

    }
    @IBAction func btn3clicked(_ sender: UIButton) {
        latestIssue.isSelected = false
        hotestTopic.isSelected = false
        topicClassify.isSelected = true
        
        topicsView.isHidden = false
    }
    
    @IBOutlet weak var momentsTopicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavItems()
        topicsView.isHidden = true
        
        momentsTopicsTableView.delegate = self
        momentsTopicsTableView.dataSource = self

    }

    func loadNavItems() {
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: .done, target: self, action: #selector(pop))
        self.navigationItem.setLeftBarButton(backBtn, animated: true)
        self.setNavBarTitle(title: "圈内动态")

    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
   

}


extension MomentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsTopicCell")
        return cell!
    }
}
