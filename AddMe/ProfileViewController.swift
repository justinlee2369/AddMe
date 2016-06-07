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
    @IBOutlet var facebookField: UITextField!
    @IBOutlet var linkedinField: UITextField!
    @IBOutlet var twitterField: UITextField!
    @IBOutlet var startConnectingButton: UIButton!
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*profilePhoto.image = GlobalVariables.sharedManager.addMeProfPic.image
        nameLabel.text = GlobalVariables.sharedManager.firstName + " " + GlobalVariables.sharedManager.lastName*/
        retrieveCurrentUserDetails()
        
        self.emailField.delegate = self
        self.phoneField.delegate = self
        self.facebookField.delegate = self
        self.linkedinField.delegate = self
        self.twitterField.delegate = self
        
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor = UIColor.whiteColor().CGColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
        
        if(defaults.boolForKey("SaveSuccess"))
        {
            startConnectingButton.hidden = false
            self.emailField.text = defaults.objectForKey("email") as? String
            self.phoneField.text = defaults.objectForKey("phoneNumber") as? String
            self.facebookField.text = defaults.objectForKey("facebook") as? String
            self.linkedinField.text = defaults.objectForKey("linkedin") as? String
            self.twitterField.text = defaults.objectForKey("twitter") as? String

        }
        else
        {
            startConnectingButton.hidden = true
        }
    }
    
    @IBAction func startConnectingButtonClicked(sender: AnyObject) {
//        performSegueWithIdentifier("ShowConnectSegue", sender: sender)
    }
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if (emailField.text?.characters.count > 0 || phoneField.text?.characters.count > 0 ||
            facebookField.text?.characters.count > 0 || linkedinField.text?.characters.count > 0 ||
            twitterField.text?.characters.count > 0)
        {
            saveUserDetails(emailField.text!, phone: phoneField.text!, facebook: facebookField.text!, linkedin: linkedinField.text!, twitter: twitterField.text!)
            self.defaults.setBool(true, forKey: "SaveSuccess")
            self.startConnectingButton.hidden = false
            let alert = UIAlertController(title: "Alert", message: "Your profile has been saved!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            // Saving data in fields
            defaults.setObject(self.emailField.text, forKey: "email")
            defaults.setObject(self.phoneField.text, forKey: "phoneNumber")
            defaults.setObject(self.facebookField.text, forKey: "facebook")
            defaults.setObject(self.linkedinField.text, forKey: "linkedin")
            defaults.setObject(self.twitterField.text, forKey: "twitter")

            defaults.synchronize()
        }
        // Alert
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please enter in necessary fields", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
                    self.facebookField.text = currentUser?.facebook
                    print("set prof pic, name, fb")
                } catch {
                    // We should probably handle the case where this save fails but for now
                    fatalError("Failed to fetch currentUser: \(error)")
                }
        })
    }
    
    private func saveUserDetails(email: String, phone: String, facebook: String, linkedin: String, twitter: String) {
        managedObjectContext?.performBlock(
            {
                do {
                   let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                    currentUser?.updateUserDetails(email, phone: phone, facebook: facebook, linkedin: linkedin, twitter: twitter)
                    
                } catch {
                    fatalError("Failed to fetch currentUser: \(error)")
                }
        })
    }
}