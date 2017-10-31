//
//  ActivityVoteTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ActivityVoteTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "ActivityVoteTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityVoteCell")
        tableView.register(UINib.init(nibName: "FigureVoteTableViewCell", bundle: nil), forCellReuseIdentifier: "FigureVoteCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFigureVoteVC), name: NSNotification.Name.init(figureVoteListNotification), object: nil)

    }
    
    @objc func showFigureVoteVC() {
        self.navigationController?.pushViewController(UIStoryboard.init(name: "FigureVote", bundle: Bundle.main).instantiateInitialViewController()!, animated: true)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityVoteCell")
            return activityCell!
        } else {
            let figureCell = tableView.dequeueReusableCell(withIdentifier: "FigureVoteCell")
            return figureCell!
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            NotificationCenter.default.post(name: NSNotification.Name.init(figureVoteListNotification), object: nil)
        } else {
            
        }

    }
}
