//
//  SystemConstantValue.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let isIPHONEX: Bool = { () -> Bool in
    if screenHeight == 812.0 && screenWidth == 375.0 {
        return true
    } else {
        return false
    }
}()


