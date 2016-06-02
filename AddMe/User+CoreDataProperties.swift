//
//  User+CoreDataProperties.swift
//  AddMe
//
//  Created by Aieswarya  on 6/1/16.
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

}
