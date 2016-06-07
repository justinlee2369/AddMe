//
//  User+CoreDataProperties.swift
//  AddMe
//
//  Created by Aieswarya  on 6/7/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var email: String?
    @NSManaged var facebook: String?
    @NSManaged var firstName: String?
    @NSManaged var history: [String]
    @NSManaged var lastName: String?
    @NSManaged var linkedin: String?
    @NSManaged var phone: String?
    @NSManaged var profilePhoto: NSData?
    @NSManaged var twitter: String?

}
