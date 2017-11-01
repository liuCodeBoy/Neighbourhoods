//
//  FigureVoteListViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class FigureVoteListViewController: UIViewController {

    @IBOutlet weak var figureVoteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        figureVoteTableView.delegate = self
        figureVoteTableView.dataSource = self
    
        setNavBarBackBtn()
        setNavBarTitle(title: "正在投票")
    }


}

extension FigureVoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FigureVoteCell")!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
