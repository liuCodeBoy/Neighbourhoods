//
//  PicPicKerCollectionView.swift
//  Ant
//
//  Created by LiuXinQiang on 2017/7/12.
//  Copyright © 2017年 LiuXinQiang. All rights reserved.
//

import UIKit
private let picPickerCell = "PicPickerViewCell"


class PicPicKerCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    // MARK:- 定义属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            weak var  weakself = self
            DispatchQueue.main.async {
                 weakself?.reloadData()
            }
           
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
 
      
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        // 设置collectionView的属性
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        delegate = self
        // 设置collectionView的内边距
        contentInset = UIEdgeInsets(top: CGFloat(edgeMargin), left: CGFloat(edgeMargin), bottom: 0, right: CGFloat(edgeMargin))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath as IndexPath) as! PicPickerViewCell
        
        // 2.给cell设置数据
       cell.imageView.image = indexPath.item <= images.count - 1 ? images[indexPath.item] :  UIImage.init(named: "luntan_houserent_addphoto_default")
        
      cell.removePhotoBtn.tag  = indexPath.row + 1000
      cell.removePhotoBtn.isHidden = indexPath.item <= images.count - 1 ? false : true
       
      cell.addPhotoBtn.isHidden = indexPath.item <= images.count - 1 ? true : false
        
        return cell
    }
}
