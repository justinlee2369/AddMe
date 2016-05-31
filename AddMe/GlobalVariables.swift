//
//  GlobalVariables.swift
//  AddMe
//
//  Created by Justin Lee on 5/23/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

import Foundation

class GlobalVariables {
    var firstName: String!
    var lastName: String!
    var addMeProfPic: UIImageView!
    
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}