//
//  MsgListModel.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJExtension

class MsgListModel: NSObject {
    @objc var id             : NSNumber?
    @objc var uid            : NSNumber?
    @objc var content        : String?
    @objc var picture        :[String]?
    @objc var time           : NSNumber?
    @objc var user           : String?
    @objc var from_user      : UserModel?
    
    @objc var msg_count      : NSNumber?
    @objc var msg_user       : String?
    @objc var msg_content    : String?
    @objc var number         : NSNumber?

}

