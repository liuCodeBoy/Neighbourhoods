//
//  ProfileMissionViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ProfileMissionViewController: UIViewController {
    
    @IBOutlet weak var myIssuedMission: UIButton!
    @IBOutlet weak var myReceivedMission: UIButton!
    
    @IBOutlet weak var lineView: UIView!
    
    var childView1: UIView?
    var childView2: UIView?
    
    @IBAction func btn1Clicked(_ sender: UIButton) {
        myIssuedMission.isSelected      = true
        myReceivedMission.isSelected    = false
        childView1?.isHidden            = false
        childView2?.isHidden            = true
    }
    @IBAction func btn2Clicked(_ sender: UIButton) {
        myIssuedMission.isSelected      = false
        myReceivedMission.isSelected    = true
        
        childView1?.isHidden            = true
        childView2?.isHidden            = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "我的任务")
        
        loadTableViews()

    }
    
    func loadTableViews() {
        let childVC1 = UIStoryboard.init(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "MyIssuedMissionVC") as! MyIssuedMissionTableViewController
        let childVC2 = UIStoryboard.init(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "MyReceivedMissionVC") as! MyReceivedMissionTableViewController
        
        childView1 = childVC1.view
        childView2 = childVC2.view
        
        var y = lineView.frame.origin.y + 1
        
        if isIPHONEX { y += 24 }
        
        childView1?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)
        childView2?.frame = CGRect.init(x: 0, y: y, width: UIScreen.main.bounds.width, height: screenHeight - y)

        self.addChildViewController(childVC1)
        self.addChildViewController(childVC2)
        
        self.view.addSubview(childView2!)
        self.view.addSubview(childView1!)
    }

}
