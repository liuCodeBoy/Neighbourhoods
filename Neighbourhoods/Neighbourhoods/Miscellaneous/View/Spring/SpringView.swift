//
//  SpringView.swift
//  Neighbourhoods
//
//  Created by Weslie on 26/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let closeSpringViewNotification = "com.app.closeSpringView"
let issueTopicsNotification = "com.app.issue.topics"
let issueMissionNotification = "com.app.issue.missions"
let quickLookMessageNotification = "com.app.quick.message"


class SpringView: UIView {
    
    @IBAction func missionBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(issueMissionNotification), object: nil)

    }
    @IBAction func topicBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(issueTopicsNotification), object: nil)

    }
    @IBAction func messgaeBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(quickLookMessageNotification), object: nil)

    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(closeSpringViewNotification), object: nil)
    }
    
}
