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

            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        play_lottery(token: UserDefaults.standard.string(forKey: "token")!, id: id!)
        
    }

    func play_lottery(token : String ,id : Int) -> () {
        NetWorkTool.shareInstance.play_lottery(token, id: id) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                let dict = info!["result"] as! NSDictionary
                let title = dict["title"] as? String
                self?.lotteryInfoBtn.setTitle("摇号中...", for: .normal)
                let  result =  "很遗憾，没有摇到".compare(title!).rawValue
                if result == 0 {
                    UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self?.lotteryDetialLbl.text = title
                        self?.lotteryInfoBtn.setTitle("未摇到", for: .normal)
                        self?.lotteryDetialLbl.font = UIFont.systemFont(ofSize: 14)
                        self?.lotteryBackView.backgroundColor = default_grey
                        self?.lotteryInfoBtn.backgroundColor  = default_grey
                        self?.colorfulBrand.alpha = 0
                    })
                }else{
                
                    UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self?.lotteryDetialLbl.text = title
                        self?.lotteryBackView.backgroundColor = default_orange
                        self?.lotteryInfoBtn.backgroundColor  = default_orange
                        self?.lotteryInfoBtn.setTitle("摇到啦", for: .normal)
                        self?.colorfulBrand.alpha = 1
                        self?.btnHCons.constant += 35

                    })
                    
    
                   
                }
            }else if(info?["code"] as? String == "403"){
                //服务器error
                self?.presentHintMessage(hintMessgae: "抱歉你还没有权限", completion: nil)
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "摇号")
        colorfulBrand.alpha = 0
        
        guard showText != nil else {
            colorfulBrand.alpha = 0
            lotteryInfoBtn.backgroundColor =  defaultBlueColor
            lotteryBackView.backgroundColor =  defaultBlueColor
            self.lotteryInfoBtn.isUserInteractionEnabled = true
            self.lotteryDetialLbl.text = ""
            return
        }
        let obj = showText! as NSString
        guard   obj.length > 0 else {
            self.lotteryBackView.backgroundColor = default_grey
            self.lotteryInfoBtn.backgroundColor  = default_grey
            self.lotteryInfoBtn.setTitle("未摇到", for: .normal)
            
            self.lotteryInfoBtn.isUserInteractionEnabled = false
            self.lotteryDetialLbl.text = ""
            return
        }
        btnHCons.constant += 35
        colorfulBrand.alpha = 1
        lotteryInfoBtn.backgroundColor =  default_orange
        lotteryBackView.backgroundColor =  default_orange
        self.lotteryInfoBtn.setTitle("摇到啦!", for: .normal)
        self.lotteryInfoBtn.isUserInteractionEnabled = false
        self.lotteryDetialLbl.text = showText
    }
}
