//
//  HelpViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 20/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var finishedStatusBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
   
    @IBOutlet weak var lineView: UIView!
    
    var childView1: UIView?
    var childView2: UIView?
    var childView3: UIView?
    
    @IBAction func btn2Clicked(_ sender: UIButton) {
        timeBtn.isSelected              = true
        finishedStatusBtn.isSelected    = false
        scoreBtn.isSelected             = false
        
        
    }
    @IBAction func btn3Clicked(_ sender: UIButton) {
        timeBtn.isSelected              = false
        finishedStatusBtn.isSelected    = true
        scoreBtn.isSelected             = false
        
        
    }
    @IBAction func btn4Clicked(_ sender: UIButton) {
        timeBtn.isSelected              = false
        finishedStatusBtn.isSelected    = false
        scoreBtn.isSelected             = true
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarTitle(title: "邻里帮")
        
        loadTableViews()
        
    }
    
    
    func loadTableViews() {
        let childVC1 = self.storyboard?.instantiateViewController(withIdentifier: "HelpCategoryByTimeVC")               as! HelpCategoryByTimeViewController
        let childVC2 = self.storyboard?.instantiateViewController(withIdentifier: "HelpCategoryByCompletionStatusVC")   as! HelpCategoryByCompletionStatusViewController
        let childVC3 = self.storyboard?.instantiateViewController(withIdentifier: "HelpCategoryByScoreVC")              as! HelpCategoryByScoreViewController
        
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
        
        self.view.addSubview(childView1!)
        self.view.addSubview(childView2!)
        self.view.addSubview(childView3!)
    }


}

