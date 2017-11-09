//
//  ImageShowVC.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/9.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
class ImageShowVC: UIViewController {
    @IBOutlet weak var imageScrollView: UIScrollView!
    var  index  : NSNumber?
    var  imageArr : NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let showImageArr = imageArr{
            self.imageScrollView.contentSize = CGSize.init(width: screenWidth *  CGFloat(showImageArr.count), height: screenHeight)
        for i in 0..<showImageArr.count{
            let childImageView = UIImageView.init(frame: CGRect.init(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: screenHeight))
            let pichGestrue = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchView(pinchGestureRecognizer:)))
            childImageView.addGestureRecognizer(pichGestrue)
                    childImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.imageScrollView.addSubview(childImageView)
            childImageView.sd_setImage(with: URL.init(string: showImageArr[i] as! String), placeholderImage: #imageLiteral(resourceName: "spring_view_shadow"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
        }
      }
    }
    
    
    @objc func  pinchView(pinchGestureRecognizer : UIPinchGestureRecognizer){
    let view = pinchGestureRecognizer.view;
        if (pinchGestureRecognizer.state == UIGestureRecognizerState.began || pinchGestureRecognizer.state == UIGestureRecognizerState.changed) {
//            self.view.bringSubviewToFront(pinchView)
//            sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale)
//            sender.scale = 1.0
//
//              CGAffineTransformScale((view?.transform)!, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//            view?.transform = CGAffineTransformScale((pinchGestureRecognizer.view?.transform)!, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale)
            view?.transform =  CGAffineTransform(scaleX:pinchGestureRecognizer.scale, y:  pinchGestureRecognizer.scale)
            pinchGestureRecognizer.scale = 1;
     }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar
    }

}
