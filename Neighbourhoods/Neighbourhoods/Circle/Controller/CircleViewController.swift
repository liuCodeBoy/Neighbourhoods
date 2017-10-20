//
//  CircleViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 14/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    @IBOutlet weak var topicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topicsTableView.delegate = self
        topicsTableView.dataSource = self
    
        let URLArr = [URL(string: "http://ow1i9ri5b.bkt.clouddn.com/IMG_7944.jpg"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/prototype-design-white.png"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/Sombrero.jpg")]
        let  loopView = LoopView.init(images: URLArr as! [URL], frame: CGRect.init(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 160), isAutoScroll: true)
        self.view.addSubview(loopView)

    }

}

extension CircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotTopicsCell")
        return cell!
    }
    
}
