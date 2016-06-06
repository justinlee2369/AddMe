//
//  User+CoreDataProperties.swift
//  AddMe
//
//  Created by Justin Lee on 6/3/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var profilePhoto: NSData?
    @NSManaged var email: String?
    @NSManaged var facebook: String?
    @NSManaged var linkedin: String?
    @NSManaged var twitter: String?
    @NSManaged var phone: String?

}
