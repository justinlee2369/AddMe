//
//  HistoryTableViewController.swift
//  AddMe
//
//  Created by Justin Lee on 6/6/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation

class HistoryTableViewController: UITableViewController {
    

    var data: [String] = []
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserHistoryCell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
}