//
//  FigureVoteJoinViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import NoticeBar
import TZImagePickerController
class FigureVoteJoinViewController: UIViewController {
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
    lazy var images = [UIImage]()
    @IBOutlet weak var conductSelfText: UITextView!
    @IBAction func forwardBtnClicked(_ sender: UIButton) {
        guard UserDefaults.standard.string(forKey: "token") != nil else{
            self.presentHintMessage(hintMessgae:  "你还未登录", completion: nil)
            return
        }
        guard (conductSelfText.text != nil)  else{
          self.presentHintMessage(hintMessgae:  "请完整信息的填写", completion: nil)
          return
        }
        
        NetWorkTool.shareInstance.join_vote(UserDefaults.standard.string(forKey: "token")!, name: conductSelfText.text!, image: self.images, id: 1) { [weak self](info, error) in
            
            if info?["code"] as? String == "200"{
                let result = info?["result"]
                let config = NoticeBarConfig(title: result as? String, image: nil, textColor: UIColor.white, backgroundColor:#colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1) , barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.25, completed: {
                    (finished) in
                    if finished {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }else {
                let config = NoticeBarConfig(title: info?["reult"] as? String, image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.25, completed: {
                    (finished) in
                    if finished {
                        self?.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }

    @IBOutlet weak var pickImageContainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setUpHeaderImageView()
        setNavBarBackBtn()
        setNavBarTitle(title: "我要参与")
    
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func submitAction(_ sender: Any) {
  
        
    }
}

//MARK: - 照片选择方法
extension FigureVoteJoinViewController : TZImagePickerControllerDelegate {
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
    
    
    private func showLocalPhotoGallery(){
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
    
    private func setupNotifications() {
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
    
    private func  setUpHeaderImageView(){
        
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
        
    }
    
}


