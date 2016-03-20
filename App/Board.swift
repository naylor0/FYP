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
    
    let bgRed = UIColor(netHex:0xFF9999)
    let bgGreen = UIColor(netHex:0xCCFF99)
    let bgYellow = UIColor(netHex: 0xFFFF66)
    let bgWhite = UIColor(netHex: 0xFFFFFF)
    
    struct PropertyKey {
        static let symbolsKey = "symbols"
        static let iconKey = "icon"
        static let nameKey = "name"
    }
    
    init?(symbols: Array<Symbol>, icon: Symbol, name: String) {
        // Initialize stored properties.
        self.symbols = symbols
        self.icon = icon
        self.name = name
        
        super.init()
    }
    
    func loadSampleBoard() {
        symbols.append(Symbol(word: "hi", photo: UIImage(named: "hi"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "hello", photo: UIImage(named: "hello"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "how", photo: UIImage(named: "how"), bgColor: bgGreen)!)
        symbols.append(Symbol(word: "is", photo: UIImage(named: "is"), bgColor: bgGreen)!)
        symbols.append(Symbol(word: "weather", photo: UIImage(named: "weather"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "good", photo: UIImage(named: "good"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "bad", photo: UIImage(named: "bad"), bgColor: bgRed)!)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let symbols = aDecoder.decodeObjectForKey(PropertyKey.symbolsKey) as! Array<Symbol>
        
        // Because photo is an optional property of Meal, use conditional cast.
        let icon = aDecoder.decodeObjectForKey(PropertyKey.iconKey) as! Symbol
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Must call designated initializer.
        self.init(symbols: symbols, icon: icon, name: name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(symbols, forKey: PropertyKey.symbolsKey)
        aCoder.encodeObject(icon, forKey: PropertyKey.iconKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
    }
}