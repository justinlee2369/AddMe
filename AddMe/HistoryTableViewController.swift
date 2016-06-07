//
//  HistoryTableViewController.swift
//  AddMe
//
//  Created by Justin Lee on 6/6/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
import CoreData

class HistoryTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var data: [String] = []
    
    // MARK: - UITableViewDataSource
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveCurrentUserDetails()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserHistoryCell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    private func retrieveCurrentUserDetails() -> [String] {
        managedObjectContext?.performBlock(
            {
                // Get the User from Core Data
                do {
                    let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                    print("fetched \(currentUser?.history)")
                    self.data+=(currentUser?.history)!
                    self.tableView.reloadData()
                    
                } catch {
                    // We should probably handle the case where this save fails but for now
                    fatalError("Failed to fetch currentUser: \(error)")
                }
        })
        return self.data
    }

    
}