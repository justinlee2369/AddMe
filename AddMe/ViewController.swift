//
//  ViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/6/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var btnFacebook: FBSDKLoginButton!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var homeButton: UIButton!
    
    var loginSuccess: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)

        configureFacebook()
        homeButton.hidden = true;
        if(loginSuccess && GlobalVariables.sharedManager.addMeProfPic != nil)
        {
            userProfileImage.image = GlobalVariables.sharedManager.addMeProfPic.image
            labelName.text = GlobalVariables.sharedManager.firstName + " " + GlobalVariables.sharedManager.lastName
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
            self.homeButton.hidden = false
        }
        // make home button appear
        self.performSegueWithIdentifier("ShowHomeSegue", sender: self)

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        userProfileImage.image = nil
        labelName.text = ""
    }
}





