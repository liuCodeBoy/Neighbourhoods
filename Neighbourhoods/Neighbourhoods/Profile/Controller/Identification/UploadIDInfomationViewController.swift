//
//  UploadIDInfomationViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import TZImagePickerController

class UploadIDInfomationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var IDNumTF: UITextField!
    
    var imageCount = 2
    
    var leftImgLoaded: Bool = false
    var rightImgLoaded: Bool = false
    
    var progressView: UIView?

    @IBOutlet weak var IDImgFront: UIImageView!
    @IBOutlet weak var IDImgBack: UIImageView!
    
    @IBAction func uploadClicked(_ sender: UIButton) {
        
        if nameTF.text == nil || IDNumTF.text == nil || leftImgLoaded == false || rightImgLoaded == false {
            presentHintMessage(hintMessgae: "请完善您的信息", completion: nil)
            return
        } else if IDNumTF.text?.count != 18 {
            presentHintMessage(hintMessgae: "请输入18位有效身份证", completion: nil)
            return
        } else {
            uploadIDCardPhoto(name: nameTF.text!, id_Num: IDNumTF.text!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "上传认证信息")
        
        if TARGET_IPHONE_SIMULATOR != 1 {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.sourceType = .camera
            
            
            let leftTap = UITapGestureRecognizer(target: self, action: #selector(takeLeftPhoto))
            let rightTap = UITapGestureRecognizer(target: self, action: #selector(takeRightPhot))
            
            IDImgFront.addGestureRecognizer(leftTap)
            IDImgBack.addGestureRecognizer(rightTap)
        }

    }
    
    @objc func takeLeftPhoto() {
        imageCount = 2
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    @objc func takeRightPhot() {
        imageCount = 1
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    func uploadIDCardPhoto(name: String, id_Num: String) {
        self.IDNumTF.resignFirstResponder()
        self.nameTF.resignFirstResponder()
        // MARK:- uploading data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UIView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.progressView = progress
        self.view.addSubview(progress)
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.identityAuth(access_token, up_cate: 2, name: name, id_number: id_Num, image: [IDImgFront.image!, IDImgBack.image!]) { [weak self](result, error) in
            // MARK:- upload
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            if result!["code"] as! String == "400" {
                self?.presentHintMessage(hintMessgae: "图片上传失败", completion: nil)
                self?.presentHintMessage(hintMessgae: "图片上传失败", completion: nil)
                return
            } else if result!["code"] as! String == "401" {
                self?.presentHintMessage(hintMessgae: "认证失败", completion: nil)
                return
            } else if result!["code"] as! String == "200" {
                self?.presentHintMessage(hintMessgae: "上传成功", completion: { (_) in
                    let index = self?.navigationController?.viewControllers.index(after: 0)
                    self?.navigationController?.popToViewController((self?.navigationController?.viewControllers[index!])!, animated: true)
                })
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        if imageCount == 2 {
            IDImgFront.image = chosenImg
            self.leftImgLoaded = true
        } else {
            IDImgBack.image = chosenImg
            self.rightImgLoaded = true
        }
        
        dismiss(animated: true) {
            
        }
    }
    


}
