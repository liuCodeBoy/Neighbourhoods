//
//  Extension+String.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/1.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

extension  String {
   static func getLabHeight(labelStr: String, font: UIFont, width: CGFloat) -> CGFloat {
        let statusLabelText = labelStr
        let size = CGSize(width: width, height: 900)
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as! [NSAttributedStringKey : Any] , context: nil).size
        return strSize.height
    }

}
