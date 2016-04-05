//
//  Board.swift
//  App
//
//  Created by Mark Naylor on 14/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class Board: NSObject, NSCoding {
    var symbols = [Symbol]()
    var icon: Symbol
    var name: String
    var cellSize: Int
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("boards")
    
    struct PropertyKey {
        static let symbolsKey = "symbols"
        static let iconKey = "icon"
        static let nameKey = "name"
        static let cellSizeKey = "cellSize"
    }
    
    init?(symbols: Array<Symbol>, icon: Symbol, name: String, cellSize: Int) {
        self.symbols = symbols
        self.icon = icon
        self.name = name
        self.cellSize = cellSize
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let symbols = aDecoder.decodeObjectForKey(PropertyKey.symbolsKey) as! Array<Symbol>
        let icon = aDecoder.decodeObjectForKey(PropertyKey.iconKey) as! Symbol
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let cellSize = aDecoder.decodeObjectForKey(PropertyKey.cellSizeKey) as! Int
        self.init(symbols: symbols, icon: icon, name: name, cellSize: cellSize)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(symbols, forKey: PropertyKey.symbolsKey)
        aCoder.encodeObject(icon, forKey: PropertyKey.iconKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(cellSize, forKey: PropertyKey.cellSizeKey)
    }
}