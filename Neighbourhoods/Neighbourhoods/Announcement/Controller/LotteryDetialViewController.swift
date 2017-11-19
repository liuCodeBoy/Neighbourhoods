//
//  LotteryDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 04/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class LotteryDetialViewController: UIViewController {
    
    @IBOutlet weak var colorfulBrand: UIImageView!
    @IBOutlet weak var lotteryBackView: UIView!
    @IBOutlet weak var lotteryInfoBtn: UIButton!
    @IBOutlet weak var lotteryDetialLbl: UILabel!
    @IBOutlet weak var btnHCons: NSLayoutConstraint!
    var   showText : String?
    var         id  : Int?
    
    @IBAction func lotteryClicked(_ sender: UIButton) {
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            self.presentHintMessage(target: self, hintMessgae: "您还未登录")
            return
        }
        play_lottery(token: UserDefaults.standard.string(forKey: "token")!, id: 1)
      
//        self.lotteryInfoBtn.setTitle("摇号中...", for: .normal)
//        UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            self.lotteryInfoBtn.setTitle("摇到啦!", for: .normal)
//            self.lotteryBackView.backgroundColor = default_orange
//        })
        
    }

    func play_lottery(token : String ,id : Int) -> () {
  
        NetWorkTool.shareInstance.play_lottery(token, id: id) { (info, error) in
            if info?["code"] as? String == "200"{
                let title = info!["result"] as! String
                self.lotteryInfoBtn.setTitle("摇号中...", for: .normal)
                let msg = info?["msg"] as? String
                let  result =  "摇号成功".compare(msg!).rawValue
                if result == 0{
                    UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                                    self.lotteryInfoBtn.setTitle("摇到啦!", for: .normal)
                                    self.lotteryBackView.backgroundColor = default_orange
                                    self.lotteryInfoBtn.backgroundColor  = default_orange

                    })
                    self.lotteryDetialLbl.text = title
                }else{
                    UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self.lotteryDetialLbl.text = title
                        self.lotteryInfoBtn.setTitle(title, for: .normal)
                        self.lotteryBackView.backgroundColor = default_grey
                        self.lotteryInfoBtn.backgroundColor  = default_grey
                    })
                }
            }else if(info?["code"] as? String == "401"){
                //服务器error
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if showText != nil {
            btnHCons.constant += 35
            colorfulBrand.isHidden = false
            lotteryInfoBtn.backgroundColor =  default_orange
            lotteryBackView.backgroundColor =  default_orange
            self.lotteryInfoBtn.setTitle("摇到啦!", for: .normal)
            self.lotteryInfoBtn.isUserInteractionEnabled = false
            self.lotteryDetialLbl.text = showText
        }else{
        colorfulBrand.isHidden = true
        lotteryInfoBtn.backgroundColor =  defaultBlueColor
        lotteryBackView.backgroundColor =  defaultBlueColor
        self.lotteryInfoBtn.isUserInteractionEnabled = true
        self.lotteryDetialLbl.text = ""
        }
    }
}
