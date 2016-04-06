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
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("boards")
    
    struct PropertyKey {
        static let symbolsKey = "symbols"
        static let iconKey = "icon"
        static let nameKey = "name"
    }
    
    init?(symbols: Array<Symbol>, icon: Symbol, name: String) {
        self.symbols = symbols
        self.icon = icon
        self.name = name
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let symbols = aDecoder.decodeObjectForKey(PropertyKey.symbolsKey) as! Array<Symbol>
        let icon = aDecoder.decodeObjectForKey(PropertyKey.iconKey) as! Symbol
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.init(symbols: symbols, icon: icon, name: name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(symbols, forKey: PropertyKey.symbolsKey)
        aCoder.encodeObject(icon, forKey: PropertyKey.iconKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
    }
}