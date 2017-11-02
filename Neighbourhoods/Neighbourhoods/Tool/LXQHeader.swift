//
//  LXQHeader.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/1.
//  Copyright © 2017年 NJQL. All rights reserved.
//
import MJRefresh
import UIKit

class LXQHeader: MJRefreshNormalHeader {

    override func prepare(){
        super.prepare()
        let loginView = UIImageView.init(image: UIImage.init(named: "refresh"))
        self.addSubview(loginView)
        self.lastUpdatedTimeLabel.isHidden = true
        
    }

    override func placeSubviews() {
        super.placeSubviews()
        
    }
}
