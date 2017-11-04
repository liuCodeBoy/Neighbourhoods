//
//  LotteryDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 04/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class LotteryDetialViewController: UIViewController {
    
    @IBOutlet weak var lotteryBackView: UIView!
    @IBOutlet weak var lotteryInfoBtn: UIButton!
    @IBOutlet weak var lotteryDetialLbl: UILabel!
    
    @IBAction func lotteryClicked(_ sender: UIButton) {
        
        self.lotteryInfoBtn.setTitle("摇号中...", for: .normal)
        
        UIView.animate(withDuration: 3, delay: 3, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.lotteryInfoBtn.setTitle("摇到啦!", for: .normal)
            self.lotteryBackView.backgroundColor = default_orange
        })

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
