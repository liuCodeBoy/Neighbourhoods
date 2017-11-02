//
//  FigureVoteJoinViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class FigureVoteJoinViewController: UIViewController {

    @IBOutlet weak var forwardbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarBackBtn()
        setNavBarTitle(title: "我要参与")
        setRoundRect(targets: [forwardbtn])
    
    }

}
