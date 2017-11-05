//
//  MyMissionsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

enum MissionStatus: String {
    case `default` = "未领取"
    case process = "已领取"
    case done = "已完成"
}

class MyMissionsViewController: UIViewController {
    
    @IBOutlet weak var myIssueMissionBtn: UIButton!
    @IBOutlet weak var receivedMissionBtn: UIButton!
    
    var childView: UIView?
    
    @IBOutlet weak var lineView: UIView!
    @IBAction func btn1Clicked(_ sender: UIButton) {
        myIssueMissionBtn.isSelected    = true
        receivedMissionBtn.isSelected   = false
        missionsTableView.isHidden      = false
        childView?.isHidden             = true
    }
    @IBAction func btn2Clicked(_ sender: UIButton) {
        myIssueMissionBtn.isSelected    = false
        receivedMissionBtn.isSelected   = true
        missionsTableView.isHidden      = true
        childView?.isHidden             = false
    }
    
    @IBOutlet weak var missionsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarBackBtn()
        self.setNavBarTitle(title: "我的任务")
        missionsTableView.delegate = self
        missionsTableView.dataSource = self
        
        loadTableViews()
        childView?.isHidden = true

    }
    
    func loadTableViews() {

        let childVC = self.storyboard?.instantiateViewController(withIdentifier: "ReceivedMissionsVC") as! ReceivedMissionsViewController
        childView = childVC.view
        let y = lineView.frame.origin.y + 1
        childView?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)

        self.addChildViewController(childVC)
        self.view.addSubview(childView!)
    }



}


extension MyMissionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssuedMissionsCell")  as! MyMissionsTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.scoreBtn.titleLabel?.text = MissionStatus.default.rawValue
        case 1:
            cell.scoreBtn.titleLabel?.text = MissionStatus.process.rawValue
        case 2:
            cell.scoreBtn.titleLabel?.text = MissionStatus.done.rawValue
            cell.marginView.backgroundColor = #colorLiteral(red: 0.3019607961, green: 0.6941176653, blue: 0.980392158, alpha: 1)
        default:
            cell.scoreBtn.titleLabel?.text = "未领取"
        }
        return cell
    }
}
