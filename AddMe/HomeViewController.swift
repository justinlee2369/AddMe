//
//  HomeViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/23/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
import CoreData
class HomeViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    @IBOutlet var welcomeText: UILabel!
    @IBOutlet var profPic: UIImageView!
    @IBAction func profileButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("ShowProfileSegue", sender: sender)
    }
    @IBAction func connectButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("ShowControllerSegue", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profPic.image = GlobalVariables.sharedManager.addMeProfPic.image
        /*welcomeText.text = "Welcome " + GlobalVariables.sharedManager.firstName + " " + GlobalVariables.sharedManager.lastName + "!"*/
        
        retrieveCurrentUserDetails()
    }
    
    private func retrieveCurrentUserDetails() {

        managedObjectContext?.performBlock(
        {
            // Get the User from Core Data
            
            do {
                let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                print("fetched \(currentUser?.firstName)")
                self.welcomeText.text = "Welcome " + currentUser!.firstName! + " " + currentUser!.lastName! + "!"
            } catch {
                // We should probably handle the case where this save fails but for now
                fatalError("Failed to fetch currentUser: \(error)")
            }
        })
    }
    
}