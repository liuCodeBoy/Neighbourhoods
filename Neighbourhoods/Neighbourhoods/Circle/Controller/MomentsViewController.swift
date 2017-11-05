//
//  MomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
class MomentsViewController: UIViewController {
    
    @IBOutlet weak var latestIssue: UIButton!
    @IBOutlet weak var hotestTopic: UIButton!
    @IBOutlet weak var topicClassify: UIButton!
    
    @IBOutlet weak var lineView: UIView!
    
    var childView1: UIView?
    var childView2: UIView?
    var childView3: UIView?

    @IBAction func btn1clicked(_ sender: UIButton) {
        latestIssue.isSelected   = true
        hotestTopic.isSelected   = false
        topicClassify.isSelected = false
        
        childView1?.isHidden = false
        childView2?.isHidden = true
        childView3?.isHidden = true
    }
    @IBAction func btn2clicked(_ sender: UIButton) {
        latestIssue.isSelected    = false
        hotestTopic.isSelected    = true
        topicClassify.isSelected  = false
        
        childView1?.isHidden = true
        childView2?.isHidden = false
        childView3?.isHidden = true
    }
    @IBAction func btn3clicked(_ sender: UIButton) {
        latestIssue.isSelected   = false
        hotestTopic.isSelected   = false
        topicClassify.isSelected = true
        
        childView1?.isHidden = true
        childView2?.isHidden = true
        childView3?.isHidden = false
    }
    
    lazy var  rotaionArray = [NborCircleModel]()
    lazy var  hotArray     = [NborCircleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "圈内动态")
        
        loadTableViews()
        
    }
    
    func loadTableViews() {
        let childVC1 = self.storyboard?.instantiateViewController(withIdentifier: "MomentsLatestIssueTVC") as! MomentsLatestIssueTableViewController
        let childVC2 = self.storyboard?.instantiateViewController(withIdentifier: "MomentsHotestTopicTVC") as! MomentsHotestTopicTableViewController
        let childVC3 = self.storyboard?.instantiateViewController(withIdentifier: "MomentsTopicsClassificationTVC") as! MomentsTopicsClassificationTableViewController
        
        childView1 = childVC1.view
        childView2 = childVC2.view
        childView3 = childVC3.view
        
        let y = lineView.frame.origin.y + 1
        
        childView1?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)
        childView2?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)
        childView3?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)
        
        
        self.addChildViewController(childVC1)
        self.addChildViewController(childVC2)
        self.addChildViewController(childVC3)
        
        self.view.addSubview(childView3!)
        self.view.addSubview(childView2!)
        self.view.addSubview(childView1!)
    }

}




