//
//  User.swift
//  AddMe
//
//  Created by Aieswarya  on 5/31/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    class func createUserWithFBDetails(firstName: String, lastName: String, profilePic: UIImage, inManagedObjectContext context:NSManagedObjectContext ) -> User?
    {
        if let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as? User{
            newUser.firstName = firstName
            newUser.lastName = lastName
            newUser.profilePhoto = NSData(data: UIImageJPEGRepresentation(profilePic, 1.0)!)

            return newUser
        }
        
        return nil
    }
    
    func getProfilePic() -> UIImage
    {
        return UIImage(data:self.profilePhoto!,scale:1.0)!
    }
    
    func updateUserDetails(email: String, phone: String, facebook: String, linkedin: String, twitter: String)
    {
        self.email = email
        self.phone = phone
        self.facebook = facebook
        self.linkedin = linkedin
        self.twitter = twitter
    }

}
