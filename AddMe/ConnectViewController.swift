//
//  ConnectViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/26/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation

class ConnectViewController : UIViewController {
    @IBOutlet var connectionsLabel: UILabel!
    @IBOutlet var textField: UITextField!
    let addMeService = AddMeServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        addMeService.delegate = self

    }
  
    @IBAction func submitButtonTapped(sender: AnyObject) {
        print("***" + textField.text!)
        addMeService.sendText(textField.text!)
    }
    
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
}




extension ConnectViewController : AddMeServiceManagerDelegate {
    
    
    func connectedDevicesChanged(manager: AddMeServiceManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
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
                let alert = UIAlertController(title: "Alert", message: textString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            
            }
        }

    }
    
}