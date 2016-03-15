//
//  Board.swift
//  App
//
//  Created by Mark Naylor on 15/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import Foundation
import CoreData


class BoardItem: NSManagedObject {

    @NSManaged var icon: String?
    @NSManaged var name: String?
    @NSManaged var relSymbol: NSManagedObject?

}
