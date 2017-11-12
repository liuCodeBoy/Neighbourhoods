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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "个人资料")
//        loadGenderPicker()
        
        let picker = Bundle.main.loadNibNamed("GenderSelectPickerView", owner: self, options: nil)?.first as! GenderSelectPickerView
        picker.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 240)
        genderPicker = picker
        self.view.addSubview(picker)
    }
    
    
    
    
//    func loadGenderPicker() {
//        self.genderPicker.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 200)
//        self.genderPicker.dataSource = self
//        self.genderPicker.delegate = self
//        self.genderPicker.backgroundColor = UIColor.init(white: 0.98, alpha: 1)
//        self.view.addSubview(genderPicker)
//
//    }
    
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
                self.genderPicker?.frame.origin.y = screenHeight - tabBarHeight - 300
            })
        case 4:
            
        // MARK:- judge wheater the user's id is verified
            // TODO:- verify succeeded
            if true {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotVerified") as! NotVerifiedIDInfomationViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
            // TODO:- verify failed
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyFailed") as! VerifyIDInfomationFailedViewController
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        // MARK:- not uploaded verification infomation
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotVerified") as! NotVerifiedIDInfomationViewController
//            self.navigationController?.pushViewController(vc, animated: true)

        default: break
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
        } else if segue.identifier == "SelectDistrictSegue" {
            let dest = segue.destination as! SelectDistrictTableViewController
            
            //MARK: - pass source vc segue
            dest.retSegue = segue
            
        }
    }
    
}
