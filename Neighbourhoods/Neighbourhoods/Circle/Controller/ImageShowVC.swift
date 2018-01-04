//
//  ImageShowVC.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/9.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class ImageShowVC: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var pageLab: UILabel!
    @IBOutlet weak var imageScrollView: UIScrollView!
    var  index  : NSNumber?
    var  imageArr : NSArray?
    var  lastPoint : CGPoint?
    var x = 0
    var y = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if let showImageArr = imageArr{
            let imageNum = showImageArr.count
            self.imageScrollView.contentSize = CGSize.init(width: screenWidth * CGFloat(imageNum), height: imageScrollView.bounds.height)
            self.imageScrollView.isPagingEnabled = true
            for i in 0..<imageNum{
            let childImageView = UIImageView.init(frame: CGRect.init(x: screenWidth * CGFloat(i) , y: 30, width: screenWidth , height: screenHeight - 60))
            childImageView.isUserInteractionEnabled = true
            childImageView.contentMode = .scaleAspectFit
            childImageView.sd_setImage(with: URL.init(string: showImageArr[i] as! String), placeholderImage: #imageLiteral(resourceName: "img_loading_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
            imageScrollView.addSubview(childImageView)
            }
            let startPage = Int(index!) + 1
            self.pageLab.text = "\(String(describing: startPage))"+"/"+"\(imageNum)"
            self.imageScrollView.setContentOffset(CGPoint.init(x:CGFloat(index!) * screenWidth , y: 0), animated: false)
      }
      self.imageScrollView.delegate = self
      self.imageScrollView.bounces  = false
      self.imageScrollView.showsVerticalScrollIndicator   = false
      self.imageScrollView.showsHorizontalScrollIndicator = false
      let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTap(sender:)))
       self.imageScrollView.addGestureRecognizer(gesture)
    }
    
    
    //pagecontroll的委托方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if let showImageArr = imageArr{
        let imageNum = showImageArr.count
        let  page = Int(scrollView.contentOffset.x / scrollView.frame.size.width) + 1;
        // 设置页码
        self.pageLab.text = "\(String(describing: page))"+"/"+"\(imageNum)"
        }
    }

    
    
    @objc func  pinchView(pinchGestureRecognizer : UIPinchGestureRecognizer){
        let view = pinchGestureRecognizer.view;
        let _width = view?.bounds.width
        let _height = view?.bounds.height
        view?.bounds.size = CGSize(width: _width! * pinchGestureRecognizer.scale, height: _height! * pinchGestureRecognizer.scale)
        pinchGestureRecognizer.scale = 1;
    }
    
    @objc func panView(panView : UIPanGestureRecognizer){
        //得到拖的过程中的xy坐标
        let transX = panView.translation(in: panView.view).x
        let transY = panView.translation(in: panView.view).y
        UIView.animate(withDuration: 0.2) {
            panView.view?.transform = CGAffineTransform(translationX: transX, y: transY)
        }
    }
    
    @objc func viewTap(sender : UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar
    }

}
//
//            self.imageScrollView.addSubview(backgroundView)
//            let childImageView = UIImageView.init(frame: CGRect.init(x: 0 , y: 0, width: screenWidth , height: screenHeight))
//            childImageView.isUserInteractionEnabled = true
//            //建立手势识别器
//            let gesture = UIPanGestureRecognizer(target: self, action:  #selector(panView(panView:)))
//            //附加识别器到视图
//            childImageView.addGestureRecognizer(gesture)
//            let pichGestrue = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchView(pinchGestureRecognizer:)))
//            childImageView.addGestureRecognizer(pichGestrue)
//
//            childImageView.contentMode = UIViewContentMode.scaleAspectFit
//            self.imageScrollView.addSubview(childImageView)
//            childImageView.sd_setImage(with: URL.init(string: showImageArr[index as! Int] as! String), placeholderImage: #imageLiteral(resourceName: "img_loading_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
//        }
