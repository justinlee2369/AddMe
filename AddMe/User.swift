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

    class func createUserWithFBDetails(firstName: String, lastName: String, inManagedObjectContext context:NSManagedObjectContext ) -> User?
    {
        if let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as? User{
            newUser.firstName = firstName
            newUser.lastName = lastName
            return newUser
        }
        
        return nil
    }

}
