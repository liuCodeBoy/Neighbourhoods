//
//  FigureVoteDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class FigureVoteDetialViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rankLbl: UILabel!
    @IBOutlet weak var detialTextView: UITextView!
    @IBOutlet weak var detialImage: UIImageView!
    @IBOutlet weak var votedCountLbl: UILabel!
    @IBOutlet weak var voteForHimHer: UIButton!
    @IBAction func voteForHimHerClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarBackBtn()
        setNavBarTitle(title: "某某人")
    
    }


}
