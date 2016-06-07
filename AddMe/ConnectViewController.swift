//
//  ConnectViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/26/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
import CoreData
import Contacts

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
    var message : NSData?
    
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
        self.message = nil
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
                        "firstName": ((currentUser?.firstName)!),
                        "lastName": ((currentUser?.lastName)!)
                    ]
                    
                    if(self.emailSwitch.on)
                    {
                        //print((currentUser?.email)!)
                        //self.message.appendContentsOf((currentUser?.email)!)
                        let emailString = self.defaults.objectForKey("email") as? String
                        print(emailString)
                        jsonObject["email"] = (emailString!)
                        //self.message.appendContentsOf(emailString!)
                        
                    }
                    if(self.phoneSwitch.on)
                    {
                        let phoneString = self.defaults.objectForKey("phoneNumber") as? String
                        print(phoneString)
                        jsonObject["phoneNumber"] = (phoneString!)
                        
                        //self.message.appendContentsOf((currentUser?.phone)!)
                    }
                    if(self.facebookSwitch.on)
                    {
                        let facebookString = self.defaults.objectForKey("facebook") as? String
                        print(facebookString)
                        jsonObject["facebook"] = (facebookString!)
                        
                        //self.message.appendContentsOf((currentUser?.facebook)!)
                    }
                    if(self.linkedinSwitch.on)
                    {
                        let linkedinString = self.defaults.objectForKey("linkedin") as? String
                        print(linkedinString)
                        jsonObject["linkedin"] = (linkedinString!)
                        
                        //self.message.appendContentsOf((currentUser?.linkedin)!)

                    }
                    if(self.twitterSwitch.on)
                    {
                        let twitterString = self.defaults.objectForKey("twitter") as? String
                        print(twitterString)
                        jsonObject["twitter"] = (twitterString!)
                        
                        //self.message.appendContentsOf((currentUser?.twitter)!)
                    }
                    let valid = NSJSONSerialization.isValidJSONObject(jsonObject) // true
                    print("Json valid: \(valid)")
                    
                    
                    do {
                        let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted)
                        // here "jsonData" is the dictionary encoded in JSON data
                        
                        self.message = jsonData
                        let decoded = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                        print(decoded)
                        
                        //print("** \(self.message)")

                        
                    } catch let error as NSError {
                        print(error)
                    }
                    
                    
                    //self.message = jsonObject.description
                    //print("** \(self.message)")

                    
                    self.addMeService.sendText(self.message!)

                    
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
    
    /*func textAlert(manager: AddMeServiceManager, textString: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if (!textString.isEmpty)
            {
//                let alert = UIAlertController(title: "Alert", message: textString, preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
                
                // Unwrap json from string
                print(textString)
                
                //var data = textString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
                do {
                    
                    
                    //var json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    // decoded
                    let json = try NSJSONSerialization.JSONObjectWithData(textString, options: [])
                    
                    if let dict = json as? [String: AnyObject] {
                        let name = dict["name"] as? [AnyObject]
                        print(name)
                        let email = dict["email"] as? [AnyObject]
                        print(email)

                        
                        /*if let weather = dict["weather"] as? [AnyObject] {
                            for dict2 in weather {
                                let id = dict2["id"] as? Int
                                let main = dict2["main"] as? String
                                let description = dict2["description"] as? String
                                print(id)
                                print(main)
                                print(description)
                            }
                        }*/
                    }
                    
                }
                catch {
                    print(error)
                }

                
                
                
                self.receivingInfoBox.text = textString
            
            }
        }

    }*/
    
    
    func textAlert(manager: AddMeServiceManager, textString: NSData) {
        // Creating a mutable object to add to the contact
        let contact = CNMutableContact()
        var fname:String?
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if (textString.length > 0)
            {
               // Unwrap json from string
               do {
                    
                    // decoded
                    let json = try NSJSONSerialization.JSONObjectWithData(textString, options: [])
                    print(json)
                
                    if let dict = json as? [String: AnyObject] {
                        fname = dict["firstName"] as? String
                        print(fname)
                        let lname = dict["lastName"] as? String
                        print(lname)
                        
                        contact.givenName = fname!
                        contact.familyName = lname!
                        
                        let email = dict["email"] as? String
                        print(email)
                        
                        if(email != nil){
                            let homeEmail = CNLabeledValue(label:CNLabelHome , value:email!)
                            contact.emailAddresses = [homeEmail]
                        }
                        
                        let phone = dict["phoneNumber"] as? String
                        print(phone)
                        
                        if(phone != nil){
                            contact.phoneNumbers = [CNLabeledValue(label:CNLabelPhoneNumberMain, value:CNPhoneNumber(stringValue: phone!))]
                        }
                        
                        let facebook = dict["facebook"] as? String
                        print(facebook)
                        
                        if(facebook != nil){
                            let facebookProfile = CNLabeledValue(label: "Facebook", value:
                            CNSocialProfile(urlString: facebook!, username: nil,
                                userIdentifier: nil, service: CNSocialProfileServiceFacebook))
                            contact.socialProfiles = [facebookProfile]
                        }
                        
                        let twitter = dict["twitter"] as? String
                        print(twitter)
                        
                        if(twitter != nil){
                             let twitterProfile = CNLabeledValue(label: "Twitter", value: CNSocialProfile(urlString: twitter!, username: nil, userIdentifier: nil, service: CNSocialProfileServiceTwitter))
                            contact.socialProfiles.append(twitterProfile)
                        }
                        
                        let linkedin = dict["linkedin"] as? String
                        print(linkedin)
                        
                        if(linkedin != nil){
                            let linkedinProfile = CNLabeledValue(label: "LinkedIn", value: CNSocialProfile(urlString: linkedin!, username: nil, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn ))
                            contact.socialProfiles.append(linkedinProfile)
                        }
                        
                        contact.organizationName = "AddMe"
                        
                    }
                    
                }
                catch {
                    print(error)
                }
                
                //self.receivingInfoBox.text = textString
                
                // Saving the newly created contact
                let store = CNContactStore()
                let saveRequest = CNSaveRequest()
                saveRequest.addContact(contact, toContainerWithIdentifier:nil)
                try! store.executeSaveRequest(saveRequest)

                print("Contact saved!!")
                let alert = UIAlertController(title: "Notification", message: "\(fname!) has been added to your contacts!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }
        }
        
    }

    
}
