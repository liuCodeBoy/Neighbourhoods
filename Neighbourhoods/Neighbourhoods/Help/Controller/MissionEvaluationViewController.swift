//
//  MissionEvaluationViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 11/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import TZImagePickerController

class MissionEvaluationViewController: UIViewController, UITextViewDelegate {
    
    var missionID: Int?
    
    var uid: Int?
    
    var starCount: Int = 0
    
    var isConfirmed: Bool = true
    
    var evaluationDetial: String?
    
    var progressView: UIView?
    
    //pictrueView
    var picPickerView : PicPicKerCollectionView?
    //默认背景照片
    var  defaultImage  : UIImageView?
    //headerLable
    var  headerLable : UILabel?
    //detailLable
    var  detailLable : UILabel?
    //定义默认上传图片的最大数额
    let maxNum = 1
    //
    lazy var images = [UIImage]()
    
    @IBOutlet weak var starCountImg: UIImageView!
    @IBOutlet weak var detialPlaceholderLbl: UILabel!
    @IBOutlet weak var detialTextView: UITextView!
    @IBOutlet weak var pickImageContainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setUpHeaderImageView()
        
        detialTextView.delegate = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "评价")
        
        let issueBtn = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(userOperateMission))
        self.navigationItem.setRightBarButton(issueBtn, animated: true)
        
       

    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.evaluationDetial = detialTextView.text
        detialPlaceholderLbl.isHidden = true
    }
    
    @IBAction func oneStarClicked(_ sender: UIButton) {
        starCount = 1
        starCountImg.image = #imageLiteral(resourceName: "evaluate_one")
    }
    @IBAction func twoStarClicked(_ sender: UIButton) {
        starCount = 2
        starCountImg.image = #imageLiteral(resourceName: "evaluate_two")
    }
    @IBAction func threeStarClicked(_ sender: UIButton) {
        starCount = 3
        starCountImg.image = #imageLiteral(resourceName: "evaluate_three")
    }
    @IBAction func fourStarClicked(_ sender: UIButton) {
        starCount = 4
        starCountImg.image = #imageLiteral(resourceName: "evaluate_four")
    }
    @IBAction func fiveStarClicked(_ sender: UIButton) {
        starCount = 5
        starCountImg.image = #imageLiteral(resourceName: "evaluate_five")
    }
    
    @objc func userOperateMission() {
        
        guard let missionID = missionID else { return }
        guard let uid = self.uid else { return }
        
        guard starCount != 0 else {
            self.presentHintMessage(hintMessgae: "你还未评分", completion: nil)
            return
        }
        
        // MARK:- detial cannot be nil or ""
        guard evaluationDetial != nil && evaluationDetial != "" && evaluationDetial?.replacingOccurrences(of: " ", with: "") != "" else {
            self.presentHintMessage(hintMessgae: "评价内容不能为空", completion: nil)
            return
        }
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        // MARK:- upload image or not
        var uploadImg: UIImage?
        var imgCount: Int?
        if images.count != 0 {
            uploadImg = images.first!
            imgCount = 1
        }

        // MARK:- uploading data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "发布中"
        self.progressView = progress
        self.view.addSubview(progress)
        
        NetWorkTool.shareInstance.evaluateTask(access_token, id: missionID, uid: uid, star: starCount, content: evaluationDetial!, up_cate: imgCount, image: uploadImg) { [weak self](result, error) in
            if error != nil {
                self?.presentHintMessage(hintMessgae: "\(String(describing: error))", completion: nil)
                return
            } else if result!["code"] as! String == "200" {
                
                // MARK:- perform evaluation
                if let strongSelf = self {
                    strongSelf.isConfirmed ? strongSelf.userConfirmMissionComplete() : strongSelf.userRejectMission()
                }

                
            } else if result!["code"] as! String == "401" {
                self?.presentHintMessage(hintMessgae: "评价失败", completion: { (_) in
                    return
                })
            } else if result!["code"] as! String == "400" {
                self?.presentHintMessage(hintMessgae: "图片上传失败", completion: { (_) in
                    return
                })
            }
        }
        
    }
    
    
    func userConfirmMissionComplete() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        NetWorkTool.shareInstance.operateTask(access_token, id: self.missionID!, type: .done) { [weak self](result, error) in
            
            // MARK:- upload
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self?.presentHintMessage(hintMessgae: "确认成功", completion: { (_) in
                    self?.navigationController?.popToRootViewController(animated: true)

                })
            } else if result!["code"] as! String == "401" {
                self?.presentHintMessage(hintMessgae: "提交失败", completion: nil)
                
            } else if result!["code"] as! String == "400" {
                self?.presentHintMessage(hintMessgae: "查询失败", completion: nil)
            } else {
                //print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }
    
    func userRejectMission() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        NetWorkTool.shareInstance.operateTask(access_token, id: self.missionID!, type: .reject) { [weak self](result, error) in
            
            // MARK:- upload
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self?.presentHintMessage(hintMessgae: "驳回成功", completion: { (_) in
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            } else if result!["code"] as! String == "401" {
                self?.presentHintMessage(hintMessgae: "提交失败", completion: nil)
                
            } else if result!["code"] as! String == "400" {
                self?.presentHintMessage(hintMessgae: "查询失败", completion: nil)
            } else {
                //print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }

}

//MARK: - 照片选择方法
extension MissionEvaluationViewController : TZImagePickerControllerDelegate {
    @objc func addPhotoClick() -> () {
        weak var  weakself = self
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionPhoto = UIAlertAction.init(title: "选择上传照片", style: .default) { (UIAlertAction) -> Void in
            if   (self.picPickerView?.images.count)! < (weakself?.maxNum)! {
                self.showLocalPhotoGallery()}
            else{
                self.presentHintMessage(hintMessgae: "你的上传图片已经达到最大数额", completion: nil)
            }
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionPhoto)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showLocalPhotoGallery(){
        weak var  weakself = self
        
        let  pushNumber = maxNum - (self.picPickerView?.images.count)!
        let  imagePickerVc = TZImagePickerController.init(maxImagesCount: pushNumber, delegate: self as TZImagePickerControllerDelegate)
        
        imagePickerVc?.didFinishPickingPhotosWithInfosHandle = {(photosArr , assets ,isSelectOriginalPhoto ,infos) in
            for i in  0..<photosArr!.count {
                weakself?.images.append((photosArr?[i])!)
            }
            self.picPickerView?.images = self.images
            
        }
        
        self.present(imagePickerVc!, animated: true, completion: nil)
        
    }
    
    @objc func removePhotoClick(noti : Notification) ->  () {
        let removeAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        removeAlert.view.tintColor = UIColor.black
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        let actionPhoto = UIAlertAction.init(title: "删除该上传照片", style: .destructive) { (UIAlertAction) -> Void in
            let  tag = ((noti.object as? UIButton)?.tag)! - 1000
            self.images.remove(at: tag)
            self.picPickerView?.images = self.images
        }
        removeAlert.addAction(actionCancel)
        removeAlert.addAction(actionPhoto)
        self.present(removeAlert, animated: true, completion: nil)
        
    }
    @objc func ClickDisappare() -> () {
        self.defaultImage?.isHidden = true
        self.addPhotoClick()
    }
    
    func setupNotifications() {
        //        // 监听键盘的弹出
        //        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillChangeFrame:")), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 监听添加照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: PicPickerAddPhotoNote, object: nil)
        
        // 监听删除照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector:  #selector(removePhotoClick(noti:)) , name: PicPickerRemovePhotoNote, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func  setUpHeaderImageView(){
        
        //初始化view成为tableview的headerView
        let  headerImageView =  UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 100))
        // self.view.addSubview(headerImageView)
        headerImageView.backgroundColor = UIColor.init(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        self.pickImageContainView.addSubview(headerImageView)
        
        
        // 设置collectionView的layout
        let  layout =  UICollectionViewFlowLayout.init()
        let itemWH = (screenWidth - CGFloat(5 * edgeMargin)) / 4
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = CGFloat(edgeMargin)
        layout.minimumLineSpacing =  CGFloat(edgeMargin)
        
        let  picPickerView = PicPicKerCollectionView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 100), collectionViewLayout: layout)
        picPickerView.backgroundColor = UIColor.init(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        self.pickImageContainView?.addSubview(picPickerView)
        self.picPickerView = picPickerView
        self.view.backgroundColor = UIColor.white
        
        // 创建默认视图
        let  imageView = UIImageView.init(image: UIImage.init(named: "luntan_houserent_addphoto_default"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 100)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.init(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        imageView.contentMode = .center
        self.pickImageContainView?.addSubview(imageView)
        self.defaultImage = imageView
        
        // 为默认视图添加事件
        let gesture =  UITapGestureRecognizer.init(target: self, action: #selector(ClickDisappare))
        self.defaultImage?.isUserInteractionEnabled = true
        self.defaultImage?.addGestureRecognizer(gesture)
        
        //添加默认lable
        let   headerLable = UILabel.init()
        headerLable.frame.origin.x =  screenWidth / 2 - 50
        headerLable.textAlignment = .center
        headerLable.frame.origin.y = (self.defaultImage?.frame.maxY)! - 30
        headerLable.frame.size = CGSize.init(width: 100, height: 30)
        headerLable.textColor = UIColor.lightGray
        headerLable.text = "添加照片"
        self.defaultImage?.addSubview(headerLable)
        self.headerLable = headerLable
        
        
        let   detailLable = UILabel.init()
        detailLable.frame.origin.x =  screenWidth / 2 - 50
        detailLable.textAlignment = .center
        detailLable.frame.origin.y = (self.headerLable?.frame.maxY)!
        detailLable.frame.size = CGSize.init(width: 100, height: 15)
        detailLable.textColor = UIColor.lightGray
        detailLable.font = UIFont.systemFont(ofSize: 10)
        detailLable.text = "请选择一张图片"
        self.defaultImage?.addSubview(detailLable)
        self.detailLable = detailLable
    }
    
}
