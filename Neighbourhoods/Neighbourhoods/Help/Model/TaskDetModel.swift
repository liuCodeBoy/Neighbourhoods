//
//  TaskDetModel.swift
//  Neighbourhoods
//
//  Created by Weslie on 13/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class TaskDetModel: NSObject {
    @objc var id            : NSNumber?
    @objc var task_id       : NSNumber?
    @objc var uid           : NSNumber?
    @objc var content       : String?
    @objc var time          : String?
    @objc var pid           : NSNumber?
    @objc var user_info     : UserModel?
    @objc var info          : String?
}

