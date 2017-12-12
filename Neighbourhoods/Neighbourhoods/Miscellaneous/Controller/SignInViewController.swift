//
//  SignInViewController.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/12/12.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var scoreLab: UILabel!
    @IBOutlet weak var timesNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func dissmissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func singInAction(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
