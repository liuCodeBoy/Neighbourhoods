//
//  MsgHistoryModel.swift
//  Neighbourhoods
//
//  Created by Weslie on 26/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJExtension

class MsgHistoryModel: NSObject {
    @objc var id             : NSNumber?
    @objc var from_uid       : NSNumber?
    @objc var to_uid         : NSNumber?
    @objc var content        : String?
    @objc var time           : NSNumber?
    @objc var from_user      : UserModel?
    @objc var to_user        : UserModel?
    @objc var is_user        : NSNumber?
    
}


