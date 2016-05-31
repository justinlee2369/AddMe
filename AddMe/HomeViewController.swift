//
//  HomeViewController.swift
//  AddMe
//
//  Created by Justin Lee on 5/23/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
class HomeViewController: UIViewController {
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
        welcomeText.text = "Welcome " + GlobalVariables.sharedManager.firstName + " " + GlobalVariables.sharedManager.lastName + "!"
    }
    
}