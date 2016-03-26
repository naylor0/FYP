//
//  History+CoreDataProperties.swift
//  App
//
//  Created by Mark Naylor on 26/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension History {

    @NSManaged var word1: String?
    @NSManaged var word2: String?

}
