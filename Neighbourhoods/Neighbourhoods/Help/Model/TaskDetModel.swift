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
    @objc var uid           : NSNumber?
    @objc var title         : String?
    @objc var content       : String?
    @objc var integral      : NSNumber?
    @objc var picture       : [String]?
    @objc var time          : NSNumber?
    @objc var task_status   : NSNumber?
    @objc var receive       : UserModel?
    @objc var is_user       : NSNumber?
    @objc var user          : UserModel?
    @objc var evaluation    : EvaluationDetModel?
}

