//
//  Board.swift
//  App
//
//  Created by Mark Naylor on 14/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import Foundation
import UIKit
class Board {
    var symbols = [Symbol]()
    var icon: Symbol
    var name: String
    
    let bgRed = UIColor(netHex:0xFF9999)
    let bgGreen = UIColor(netHex:0xCCFF99)
    let bgYellow = UIColor(netHex: 0xFFFF66)
    let bgWhite = UIColor(netHex: 0xFFFFFF)
    
    init?(symbols: Array<Symbol>, icon: Symbol, name: String) {
        // Initialize stored properties.
        self.symbols = symbols
        self.icon = icon
        self.name = name
    }
    func loadSampleBoard() {
        symbols.append(Symbol(word: "hi", photo: UIImage(named: "hi"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "how", photo: UIImage(named: "how"), bgColor: bgGreen)!)
        symbols.append(Symbol(word: "is", photo: UIImage(named: "is"), bgColor: bgGreen)!)
        symbols.append(Symbol(word: "weather", photo: UIImage(named: "weather"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "good", photo: UIImage(named: "good"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "bad", photo: UIImage(named: "bad"), bgColor: bgRed)!)
    }
}