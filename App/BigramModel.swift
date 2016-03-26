//
//  BigramModel.swift
//  App
//
//  Created by Mark Naylor on 24/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//
import Foundation

class BigramModel: NSObject {
    
    //properties
    
    var word1: String
    var word2: String
    
    //constructor
    
    init(word1: String, word2: String) {
        
        self.word1 = word1
        self.word2 = word2
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "\(word1)\(word2)"
        
    }
    
    
}