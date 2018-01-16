//
//  ItemTableController.swift
//  SeanPageView_Example
//
//  Created by shibo on 2018/1/15.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class ItemTableController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "row=========\(indexPath.row)"
        return cell!
    }

}
