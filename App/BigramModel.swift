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
    
    var word1: String?
    var word2: String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(word1: String, word2: String) {
        
        self.word1 = word1
        self.word2 = word2
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Word1: \(word1), Word2: \(word2)"
        
    }
    
    
}