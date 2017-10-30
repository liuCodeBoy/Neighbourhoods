//
//  HelpViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 20/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var missionCategoryBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var finishedStatusBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var natureBtn: UIButton!
    
    
    @IBAction func btn1Clicked(_ sender: UIButton) {
        missionCategoryBtn.isSelected   = true
        timeBtn.isSelected              = false
        finishedStatusBtn.isSelected    = false
        scoreBtn.isSelected             = false
        natureBtn.isSelected            = false
        
        
    }
    @IBAction func btn2Clicked(_ sender: UIButton) {
        missionCategoryBtn.isSelected   = false
        timeBtn.isSelected              = true
        finishedStatusBtn.isSelected    = false
        scoreBtn.isSelected             = false
        natureBtn.isSelected            = false
        
        
    }
    @IBAction func btn3Clicked(_ sender: UIButton) {
        missionCategoryBtn.isSelected   = false
        timeBtn.isSelected              = false
        finishedStatusBtn.isSelected    = true
        scoreBtn.isSelected             = false
        natureBtn.isSelected            = false
        
        
    }
    @IBAction func btn4Clicked(_ sender: UIButton) {
        missionCategoryBtn.isSelected   = false
        timeBtn.isSelected              = false
        finishedStatusBtn.isSelected    = false
        scoreBtn.isSelected             = true
        natureBtn.isSelected            = false
        
        
        
    }
    @IBAction func btn5Clicked(_ sender: UIButton) {
        missionCategoryBtn.isSelected   = false
        timeBtn.isSelected              = false
        finishedStatusBtn.isSelected    = false
        scoreBtn.isSelected             = false
        natureBtn.isSelected            = true
        
        
    }
    
    
    @IBOutlet weak var missionCategoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavBarItems()
        
        missionCategoriesTableView.delegate = self
        missionCategoriesTableView.dataSource = self
        
    }
    
    // MARK:- set nav attribute and items
    func loadNavBarItems() {
        let titleLbl = UILabel()
        titleLbl.textColor = defaultBlueColor
        titleLbl.text = "邻里帮"
        self.navigationItem.titleView = titleLbl
        
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_search"), style: .done, target: self, action: #selector(navSearch))
        self.navigationItem.setLeftBarButton(leftBtn, animated: true)
        
    }
    
    @objc func navSearch() {
        
    }

}

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpMissionCell")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

