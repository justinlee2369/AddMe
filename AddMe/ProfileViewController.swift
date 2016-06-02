//
//  ProfileViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/23/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*profilePhoto.image = GlobalVariables.sharedManager.addMeProfPic.image
        nameLabel.text = GlobalVariables.sharedManager.firstName + " " + GlobalVariables.sharedManager.lastName*/
        retrieveCurrentUserDetails()
        
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor = UIColor.whiteColor().CGColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
    }
    
    private func retrieveCurrentUserDetails() {
        managedObjectContext?.performBlock(
            {
                // Get the User from Core Data
                do {
                    let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                    print("fetched \(currentUser?.firstName)")
                    
                    self.nameLabel.text = currentUser!.firstName!  + " " + currentUser!.lastName!
                    self.profilePhoto.image = currentUser?.getProfilePic()
                    print("set prof pic")
                } catch {
                    // We should probably handle the case where this save fails but for now
                    fatalError("Failed to fetch currentUser: \(error)")
                }
        })
    }
}