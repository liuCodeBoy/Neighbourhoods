//
//  UploadIDInfomationViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import TZImagePickerController

class UploadIDInfomationViewController: UIViewController, TZImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var IDNumTF: UITextField!
    
    var imageCount = 2
    
    @IBOutlet weak var IDImgFront: UIImageView!
    @IBOutlet weak var IDImgBack: UIImageView!
    
    @IBAction func uploadClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "上传认证信息")
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(takeLeftPhoto))
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(takeRightPhot))

        IDImgFront.addGestureRecognizer(leftTap)
        IDImgBack.addGestureRecognizer(rightTap)

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

    
//    @objc func takePhoto(sender: UIImageView) {
//        let sheet = UIAlertController()
//        let imagePickerVC = TZImagePickerController(maxImagesCount: 1, delegate: self)
//        let photoLib = UIAlertAction(title: "选择照片", style: .default, handler: { (_) in
//            imagePickerVC?.allowPickingOriginalPhoto = false
//            imagePickerVC?.allowCrop = true
//            weak var wealSelf = self
//            imagePickerVC?.didFinishPickingPhotosWithInfosHandle = {(photosArr, _ , _, _) in
//                if sender.image == #imageLiteral(resourceName: "upload_id_card2") {
//                    wealSelf?.IDImgFront.image = photosArr?.first!
//                } else {
//                    wealSelf?.IDImgBack.image = photosArr?.first!
//                }
//                if self.imageCount == 0 {
//                    wealSelf?.IDImgFront.image = photosArr?.first!
//                } else {
//                    wealSelf?.IDImgBack.image = photosArr?.first!
//                }
//
//            }
//            self.present(imagePickerVC!, animated: true, completion: {
//
//            })
//        })
//        let takePhoto = UIAlertAction(title: "拍照", style: .default, handler: { (_) in
//            let imagePicker = UIImagePickerController()
//            imagePicker.sourceType = .camera
//            imagePicker.allowsEditing = true
//            imagePicker.delegate = self
//            self.present(imagePicker, animated: true, completion: {
//
//            })
//        })
//        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
//
//        })
        
//        sheet.addAction(takePhoto)
//        sheet.addAction(photoLib)
//        sheet.addAction(cancel)
//
//
//        self.present(sheet, animated: true, completion: {
//
//        })
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        if imageCount == 2 {
            IDImgFront.image = chosenImg
        } else {
            IDImgBack.image = chosenImg
        }
        
        dismiss(animated: true) {
            
        }
    }
    


}
