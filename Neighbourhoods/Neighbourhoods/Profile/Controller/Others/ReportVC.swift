//
//  ReportVC.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/12/6.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {
    @IBOutlet weak var reportContext: UITextView!
    private var selectedNum = 0
    @IBOutlet weak var submit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func shanBtn(_ sender: Any) {
        let shanBtn = sender as? UIButton
        if  shanBtn?.isSelected == false{
            shanBtn?.isSelected = true
            shanBtn?.backgroundColor = #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1)
            shanBtn?.setTitleShadowColor( #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1), for: .selected)
            selectedNum += 1
        }else{
            shanBtn?.isSelected = false
            shanBtn?.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            shanBtn?.setTitleShadowColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) , for: .normal)
             selectedNum -= 1
        }
    }
    @IBAction func vulgarBtn(_ sender: Any) {
        let shanBtn = sender as? UIButton
        if  shanBtn?.isSelected == false{
            shanBtn?.isSelected = true
            shanBtn?.backgroundColor = #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1)
            shanBtn?.setTitleShadowColor( #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1), for: .selected)
            selectedNum += 1
        }else{
            shanBtn?.isSelected = false
            shanBtn?.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            shanBtn?.setTitleShadowColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) , for: .normal)
            selectedNum -= 1
        }
    }
    @IBAction func discriminateBtn(_ sender: Any) {
        let shanBtn = sender as? UIButton
        if  shanBtn?.isSelected == false{
            shanBtn?.isSelected = true
            shanBtn?.backgroundColor = #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1)
            shanBtn?.setTitleShadowColor( #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1), for: .selected)
            selectedNum += 1
        }else{
            shanBtn?.isSelected = false
            shanBtn?.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            shanBtn?.setTitleShadowColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) , for: .normal)
            selectedNum -= 1
        }
    }
    @IBAction func uncomforableBtn(_ sender: Any) {
        let shanBtn = sender as? UIButton
        if  shanBtn?.isSelected == false{
            shanBtn?.isSelected = true
            shanBtn?.backgroundColor = #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1)
            shanBtn?.setTitleShadowColor( #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1), for: .selected)
            selectedNum += 1
        }else{
            shanBtn?.isSelected = false
            shanBtn?.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            shanBtn?.setTitleShadowColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) , for: .normal)
            selectedNum -= 1
        }
    }
    @IBAction func ruleBreakerBtn(_ sender: Any) {
        let shanBtn = sender as? UIButton
        if  shanBtn?.isSelected == false{
            shanBtn?.isSelected = true
            shanBtn?.backgroundColor = #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1)
            shanBtn?.setTitleShadowColor( #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1), for: .selected)
            selectedNum += 1
        }else{
            shanBtn?.isSelected = false
            shanBtn?.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            shanBtn?.setTitleShadowColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) , for: .normal)
            selectedNum -= 1
        }
    }
    @IBAction func otherBtn(_ sender: Any) {
        let shanBtn = sender as? UIButton
        if  shanBtn?.isSelected == false{
            shanBtn?.isSelected = true
            shanBtn?.backgroundColor = #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1)
            shanBtn?.setTitleShadowColor( #colorLiteral(red: 0.9921568632, green: 0.5803921819, blue: 0.1490196139, alpha: 1), for: .selected)
            selectedNum += 1
        }else{
            shanBtn?.isSelected = false
            shanBtn?.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            shanBtn?.setTitleShadowColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) , for: .normal)
            selectedNum -= 1
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        guard self.selectedNum > 0  else {
            self.presentHintMessage(hintMessgae: "至少选择一种类型", completion: nil)
            return
        }
        self.presentHintMessage(hintMessgae: "提交成功") { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reportContext.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
