//
//  SymbolItem.swift
//  App
//
//  Created by Mark Naylor on 15/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import Foundation
import CoreData


class SymbolItem: NSManagedObject {

    @NSManaged var photo: String?
    @NSManaged var word: String?

}
