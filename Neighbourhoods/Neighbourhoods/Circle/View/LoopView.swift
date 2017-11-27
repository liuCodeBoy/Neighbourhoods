//
//  LoopView.swift
//
//
//  Created by WangYiqiao on 16/11/24.
//  Copyright © 2016年 wyq. All rights reserved.
//


// MARK:- Usage

/*
 imageScrollView.images = images
 imageScrollView.isAutoScroll = true
 imageScrollView.imageClickedHandler = { (indexOfImage) -> Void in
 print("the index of clicked image: \(indexOfImage)")
 }
*/


import UIKit
import SDWebImage

class LoopView: UIView, UIScrollViewDelegate
{
    //views
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.defersCurrentPageDisplay = true
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    //time interval of auto scrolling
    private let kAutoScrollInterval: TimeInterval = 5.0
    
    private var frameWidth: CGFloat!
    private var frameHeight: CGFloat!
    private var scrollTimer: Timer? = nil
    
    //image clicked action, parameter: the index of clicked image
    var imageClickedHandler: ((Int) -> Void)?

    var images: [URL] = [] {
        didSet {
            layoutIfNeeded()
        }
    }
    
    var isAutoScroll = true
    
    //MARK: - Init
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    convenience init(images: [URL], frame: CGRect, isAutoScroll: Bool) {
        self.init()
        self.images = images
        self.frame = frame
        self.isAutoScroll = isAutoScroll
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        frameWidth = self.bounds.size.width
        frameHeight = self.bounds.size.height
        
        scrollView.frame = self.bounds
        pageControl.center.x = self.center.x
        pageControl.center.y = self.bounds.size.height - 20
        
        updateScrollView()
        updateImageViews()
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    //MARK: - Action
    
    @objc private func tapOnImageView(recoginzer: UITapGestureRecognizer) {
        if let indexOfImage = recoginzer.view?.tag {
            self.imageClickedHandler?(indexOfImage)
        }
    }
    
    @objc private func doAutoScroll() {
        var offset = scrollView.contentOffset.x + frameWidth
        
        //scroll to the first image
        if offset > CGFloat(self.images.count) * frameWidth {
            offset = frameWidth
        }
        
        scrollView.setContentOffset(CGPoint(x: offset, y:0), animated: true)
        
        let page =  abs(Int((offset - frameWidth) / frameWidth))
        pageControl.currentPage = page
    }
    
    //MARK: - Public
    
    func startAutoScroll() {
        if scrollTimer != nil || images.count < 2 || !isAutoScroll{
            return
        }
        
        let timer = Timer.scheduledTimer(timeInterval: kAutoScrollInterval, target: self, selector: #selector(doAutoScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        self.scrollTimer = timer
    }
    
    
    func stopAutoScroll() {
        self.scrollTimer?.invalidate()
        self.scrollTimer = nil
    }
    
    // MARK: - Private
    
    private func updateScrollView() {
        pageControl.numberOfPages = images.count
        
        // 计算contentSize
        if images.count >= 2 {
            scrollView.contentSize = CGSize(width: CGFloat(images.count + 2) * frameWidth, height: 0)
            scrollView.contentOffset.x = frameWidth
        }
        else {
            scrollView.contentSize = CGSize(width: CGFloat(images.count) * frameWidth, height: 0)
            scrollView.contentOffset.x = 0
        }
    }
    
    private func updateImageViews() {

        //在首尾各多添加一张图片使之形成环
        let numOfImgviews = images.count >= 2 ? images.count + 2 : images.count
        
        for i in 0..<numOfImgviews {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * frameWidth, y: 0, width: frameWidth, height: frameHeight))
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            
            if i <= 0 {
                imageView.sd_setImage(with: self.images.last, placeholderImage: nil)
                imageView.tag = numOfImgviews - 1
            }
            else if i >= numOfImgviews - 1 {
                imageView.sd_setImage(with: self.images.first, placeholderImage: nil) 
                imageView.tag = 0
            }
            else {
                imageView.sd_setImage(with: self.images[i - 1], placeholderImage: nil)
                imageView.tag = i - 1
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImageView))
            imageView.addGestureRecognizer(tapGesture)
            
            self.scrollView.addSubview(imageView)
        }
    }
    
    //MARK: - UIScrollView delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.x
        
        if self.images.count >= 2 {
            //scroll to the last imageView
            if offset > CGFloat(self.images.count) * frameWidth {
                scrollView.contentOffset.x = frameWidth
                offset = scrollView.contentOffset.x
            }
            
            //scroll to the first imageView
            if offset < frameWidth {
                scrollView.contentOffset.x = CGFloat(self.images.count) * frameWidth
                offset = scrollView.contentOffset.x
            }
        }
        
        //计算页数
        let page =  abs(Int((offset - frameWidth) / frameWidth))
        pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}

