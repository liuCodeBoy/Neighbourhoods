//
//  SelfInfomationTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import TZImagePickerController

class SelfInfomationTableViewController: UITableViewController, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var discrictLbl: UILabel!
    
    
    lazy var images = [UIImage]()
    
    var genderPicker: GenderSelectPickerView?
    
    var nickName: String?
    
    var identityName: String?
    var identityNumber: String?
    
    var userIdentificationStatus: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "个人资料")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //initialize the picker view and hide in the buttom
        let picker = Bundle.main.loadNibNamed("GenderSelectPickerView", owner: self, options: nil)?.first as! GenderSelectPickerView
        picker.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 240)
        genderPicker = picker
        self.view.addSubview(picker)
        
        // MARK:- receive location data
        NotificationCenter.default.addObserver(self, selector: #selector(changeLocation(_:)), name: NSNotification.Name.init(locationNotification), object: nil)
        
        
        // MARK:- receive data from the picker view
        genderPicker?.genderClosure = { (gender) in
            self.genderLbl.text = gender
        }
        
        loadIdentityStatus()
    }
    
    
    
    @objc func changeLocation(_ sender: Notification) {
        self.discrictLbl.text = (sender.object as! String)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let sheet = UIAlertController()
            let imagePickerVC = TZImagePickerController(maxImagesCount: 1, delegate: self)
            let photoLib = UIAlertAction(title: "选择照片", style: .default, handler: { (_) in
                imagePickerVC?.allowPickingOriginalPhoto = false
                imagePickerVC?.allowCrop = true
                weak var wealSelf = self
                imagePickerVC?.didFinishPickingPhotosWithInfosHandle = {(photosArr, _ , _, _) in
                    wealSelf?.avatar.image = photosArr?.first!
                }
                self.present(imagePickerVC!, animated: true, completion: {
                    
                })
            })
            let takePhoto = UIAlertAction(title: "拍照", style: .default, handler: { (_) in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: {
                    
                })
            })
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
                
            })
            
            sheet.addAction(takePhoto)
            sheet.addAction(photoLib)
            sheet.addAction(cancel)

            
            self.present(sheet, animated: true, completion: {
                
            })
        case 2:
            UIView.animate(withDuration: 0.2, animations: {
                self.genderPicker?.frame = CGRect(x: 0, y: screenHeight - tabBarHeight - 240, width: screenWidth, height: 240)
            })
        case 4:
            
        // MARK:- judge wheater the user's id is verified
            if userIdentificationStatus == "身份已认证" {
            // MARK:- verify succeeded
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifySucceeded") as! VerifyIDInfomationSucceededViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else if userIdentificationStatus == "审核失败" {
            // MARK:- verify failed
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyFailed") as! VerifyIDInfomationFailedViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else if userIdentificationStatus == "身份未认证" {
            // MARK:- not uploaded verification infomation
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotVerified") as! NotVerifiedIDInfomationViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else if userIdentificationStatus == "身份待审核" {
            // TODO:- create a vc
                
            }
            
        default: break
        }
    }
    
    func loadIdentityStatus() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.identityJudge(access_token) { (result, error) in
            if result!["code"] as! String == "200" {
                let dict = result!["result"] as! [String : AnyObject]
                let idStatus = IdentityJudgeModel.mj_object(withKeyValues: dict)
                switch idStatus?.status as! Int {
                case 0: self.userIdentificationStatus = "身份未认证"
                case 1:
                    self.userIdentificationStatus = "身份已认证"
                    self.identityName = idStatus?.name
                    self.identityNumber = idStatus?.id_number
                case 2: self.userIdentificationStatus = "身份待审核"
                case 3: self.userIdentificationStatus = "审核失败"
                default: break
                }
            } else {
                print("post request failed with code : \(result!["code"] as! String)")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImg = info[UIImagePickerControllerEditedImage] as! UIImage
        self.avatar.image = chosenImg
        //MARK: - uoload image
        dismiss(animated: true) {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NickNameChangeSegue" {
            let dest = segue.destination as! ChangeNickNameViewController
            
            //MARK: - send self's segue vc to next vc
            dest.retSegue = segue
        }
    }
    
}
