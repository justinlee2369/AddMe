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
                    let currentUser = try (self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "User")) as! [User]).first
                    if(self.emailSwitch.on)
                    {
                        self.message.appendContentsOf((currentUser?.email)!)
                    }
                    if(self.phoneSwitch.on)
                    {
                        self.message.appendContentsOf((currentUser?.phone)!)
                    }
                    if(self.facebookSwitch.on)
                    {
                        self.message.appendContentsOf((currentUser?.facebook)!)
                    }
                    if(self.linkedinSwitch.on)
                    {
                        self.message.appendContentsOf((currentUser?.linkedin)!)
                    }
                    if(self.twitterSwitch.on)
                    {
                        self.message.appendContentsOf((currentUser?.twitter)!)
                    }
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