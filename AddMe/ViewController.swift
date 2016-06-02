//
//  ViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/6/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var btnFacebook: FBSDKLoginButton!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var homeButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var loginSuccess: Bool = false
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)

        configureFacebook()
        homeButton.hidden = true
        /*if(loginSuccess && GlobalVariables.sharedManager.addMeProfPic != nil)
        {
            userProfileImage.image = GlobalVariables.sharedManager.addMeProfPic.image
            labelName.text = GlobalVariables.sharedManager.firstName + " " + GlobalVariables.sharedManager.lastName
        }*/
        
        if(defaults.boolForKey("UserLoginSuccess"))
        {
            retrieveCurrentUserDetails()
            homeButton.hidden = false
        }


//        let loginButton = FBSDKLoginButton()
//        loginButton.center = self.view.center;
//        self.view.addSubview(loginButton);
        
        
    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowProfileSegue"
//        {
//            if segue.destinationViewController is ProfileViewController {
//             
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        btnFacebook.delegate = self
    }
    @IBAction func homeButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowHomeSegue", sender: self)

    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strLastName: String = (result.objectForKey("last_name") as? String)!
            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            // set variables from fb data
            GlobalVariables.sharedManager.firstName = strFirstName
            GlobalVariables.sharedManager.lastName = strLastName

            self.labelName.text = "Welcome, \(strFirstName) \(strLastName)!"
            self.userProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
            GlobalVariables.sharedManager.addMeProfPic = self.userProfileImage
            self.loginSuccess = true
            
            self.defaults.setBool(true, forKey: "UserLoginSuccess")
            
            self.homeButton.hidden = false
            
            let pfPic = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
            self.saveUserFacebookDetailsToDatabase(strFirstName, lastName: strLastName, profilePic: pfPic!)
        }
        // make home button appear
        self.performSegueWithIdentifier("ShowHomeSegue", sender: self)

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        // We want this behavior right? No home button if not logged in?
        self.defaults.setBool(false, forKey: "UserLoginSuccess")
        self.homeButton.hidden = true
        
        userProfileImage.image = nil
        labelName.text = "Welcome to Add Me!"
    }
    
    private func saveUserFacebookDetailsToDatabase(firstName: String, lastName: String, profilePic: UIImage)
    {
        managedObjectContext?.performBlock(
        {
            // create a new User object in database and set the fields gathered from Facebook
            _ = User.createUserWithFBDetails(firstName, lastName: lastName, profilePic: profilePic, inManagedObjectContext: self.managedObjectContext!)
            
            do {
                // Hopefully this save works
                try self.managedObjectContext!.save()
                
                let userCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "User"), error: nil)
                print("\(userCount) users in database")
            } catch let error{
                // We should probably handle the case where this save fails but for now
                print("Core Data Save Error \(error)")
            }
        })
    }
    
    private func retrieveCurrentUserDetails() {
        managedObjectContext?.performBlock(
            {
                // Get the User from Core Data
                
                do {
                    let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                    print("fetched \(currentUser?.firstName) in first view controller")

                    self.userProfileImage.image = currentUser?.getProfilePic()
                    print("set prof pic")

                    self.labelName.text = (currentUser?.firstName)! + " " + (currentUser?.lastName)!
                    
                } catch {
                    // We should probably handle the case where this save fails but for now
                    fatalError("Failed to fetch currentUser: \(error)")
                }
        })
    }
}





