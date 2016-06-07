//
//  ConnectViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/26/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
import CoreData

class ConnectViewController : UIViewController {
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var connectionsLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var emailSwitch: UISwitch!
    @IBOutlet var phoneSwitch: UISwitch!
    @IBOutlet var facebookSwitch: UISwitch!
    @IBOutlet var linkedinSwitch: UISwitch!
    @IBOutlet var twitterSwitch: UISwitch!
    @IBOutlet var receivingInfoBox: UILabel!
    var message : String = ""
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    let addMeService = AddMeServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        addMeService.delegate = self
        sendButton.hidden = true
    }
    // Deinitialize the delegate to prevent multiple instances of MCSessions
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        addMeService.delegate = nil
    }
    @IBAction func sendButtonClicked(sender: AnyObject) {
        self.message = ""
        retrieveCurrentUserDetails()
    }
  
//    @IBAction func submitButtonTapped(sender: AnyObject) {
//        print("***" + textField.text!)
//        addMeService.sendText(textField.text!)
//    }
    
    @IBAction func redButtonTapped(sender: AnyObject) {
        self.changeColor(UIColor.redColor())
        
        addMeService.sendColor("red")
        
    }
    
    func changeColor(color : UIColor) {
        UIView.animateWithDuration(0.2) {
            // eventually store data or open another app here with switch statement
            self.view.backgroundColor = color
        }
    }
    
    private func retrieveCurrentUserDetails() {
        managedObjectContext?.performBlock(
            {
                // Get the User from Core Data
                do {
                    var jsonObject: [String:AnyObject]
                    let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                    jsonObject = [
                        "name": (currentUser?.firstName)!
                    ]
                    
                    if(self.emailSwitch.on)
                    {
                        //print((currentUser?.email)!)
                        //self.message.appendContentsOf((currentUser?.email)!)
                        let emailString = self.defaults.objectForKey("email") as? String
                        print(emailString)
                        jsonObject["email"] = (emailString!)
                        self.message.appendContentsOf(emailString!)
                        
                    }
                    if(self.phoneSwitch.on)
                    {
                        let phoneString = self.defaults.objectForKey("phoneNumber") as? String
                        print(phoneString)
                        jsonObject["phoneNumber"] = (phoneString!)
                        
                        self.message.appendContentsOf((currentUser?.phone)!)
                    }
                    if(self.facebookSwitch.on)
                    {
                        let facebookString = self.defaults.objectForKey("facebook") as? String
                        print(facebookString)
                        jsonObject["facebook"] = (facebookString!)
                        
                        self.message.appendContentsOf((currentUser?.facebook)!)
                    }
                    if(self.linkedinSwitch.on)
                    {
                        let linkedinString = self.defaults.objectForKey("linkedin") as? String
                        print(linkedinString)
                        jsonObject["linkedin"] = (linkedinString!)
                        
                        self.message.appendContentsOf((currentUser?.linkedin)!)

                    }
                    if(self.twitterSwitch.on)
                    {
                        let twitterString = self.defaults.objectForKey("twitter") as? String
                        print(twitterString)
                        jsonObject["twitter"] = (twitterString!)
                        
                        self.message.appendContentsOf((currentUser?.twitter)!)
                    }
                    let valid = NSJSONSerialization.isValidJSONObject(jsonObject) // true
                    print("Json valid: \(valid)")
                    self.message = jsonObject.description
                    print("** \(self.message)")
                    
                    self.addMeService.sendText(self.message)

                    
                } catch {
                    // We should probably handle the case where this save fails but for now
                    fatalError("Failed to fetch currentUser: \(error)")
                }
        })
    }
    
}



extension ConnectViewController : AddMeServiceManagerDelegate {
    
    
    func connectedDevicesChanged(manager: AddMeServiceManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
            self.sendButton.hidden = false
        }
    }
    // Will happen if other device requests change
    func colorChanged(manager: AddMeServiceManager, colorString: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            switch colorString {
            case "red":
                self.changeColor(UIColor.redColor())
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
    
    func textAlert(manager: AddMeServiceManager, textString: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if (!textString.isEmpty)
            {
//                let alert = UIAlertController(title: "Alert", message: textString, preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
                self.receivingInfoBox.text = textString
            
            }
        }

    }
    
}