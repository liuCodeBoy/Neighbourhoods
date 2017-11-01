//
//  SocialCharityDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SocialCharityDetialViewController: UIViewController {
    
    @IBOutlet weak var charityAvatar: UIImageView!
    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarTitle(title: "社区公益组织")
        setNavBarBackBtn()

    }


}
