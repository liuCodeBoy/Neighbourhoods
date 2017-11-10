//
//  SelfInfomationTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SelfInfomationTableViewController: UITableViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var discrictLbl: UILabel!
    
    var nickName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "个人资料")

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            
        // MARK:- judge wheater the user's id is verified
            // TODO:- verify succeeded
            if true {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotVerified") as! NotVerifiedIDInfomationViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
            // TODO:- verify failed
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyFailed") as! VerifyIDInfomationFailedViewController
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        // MARK:- not uploaded verification infomation
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotVerified") as! NotVerifiedIDInfomationViewController
//            self.navigationController?.pushViewController(vc, animated: true)

        default: break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NickNameChangeSegue" {
            let dest = segue.destination as! ChangeNickNameViewController
            
            //MARK: - send self's segue vc to next vc
            dest.retSegue = segue
        } else if segue.identifier == "SelectDistrictSegue" {
            let dest = segue.destination as! SelectDistrictTableViewController
            
            //MARK: - pass source vc segue
            dest.retSegue = segue
            
        }
    }

}
