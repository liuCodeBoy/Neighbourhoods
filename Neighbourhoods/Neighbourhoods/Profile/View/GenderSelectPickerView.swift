//
//  GenderSelectPickerView.swift
//  Neighbourhoods
//
//  Created by Weslie on 11/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class GenderSelectPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    
    var gender: String = "男"
    
    var sex: Int = 1
    
    var genderClosure: ((_ gender: String) -> ())?
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        if gender == "男" {
            sex = 1
        } else {
            sex = 2
        }
        NetWorkTool.shareInstance.updateProfile(access_token, cate: "sex", content: nil, content_sex: self.sex, image: nil) { (result, error) in
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                //print("change gender successful")
            } else {
                //print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
        
        
        UIView.animate(withDuration: 0.2) {
            if self.genderClosure != nil {
                self.genderClosure!(self.gender)
            }
            self.frame.origin.y = screenHeight
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            gender = "男"
        } else {
            gender = "女"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return "男"
        case 1: return "女"
        default: return nil
        }
    }
}
