//
//  ProfileViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/23/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
import CoreData

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var phoneField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*profilePhoto.image = GlobalVariables.sharedManager.addMeProfPic.image
        nameLabel.text = GlobalVariables.sharedManager.firstName + " " + GlobalVariables.sharedManager.lastName*/
        retrieveCurrentUserDetails()
        
        self.emailField.delegate = self
        self.phoneField.delegate = self
        
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor = UIColor.whiteColor().CGColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if (emailField.text?.characters.count > 0)
        {
            saveUserDetails(emailField.text!)
            print(emailField.text)
            
        }
        // Alert
        else
        {
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    private func saveUserDetails(email: String) {
        managedObjectContext?.performBlock(
            {
                do {
                   let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                    currentUser?.updateUserDetails(email)
                    
                } catch {
                    fatalError("Failed to fetch currentUser: \(error)")
                }
        })
    }
}