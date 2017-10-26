//
//  SpringView.swift
//  Neighbourhoods
//
//  Created by Weslie on 26/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let closeSpringViewNotification = "com.app.closeSpringView"

class SpringView: UIView {

    @IBAction func closeBtnClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(closeSpringViewNotification), object: nil)
    }
    
}
