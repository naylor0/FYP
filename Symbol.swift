//
//  Symbol.swift
//  App
//
//  Created by Mark Naylor on 12/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class Symbol: NSObject, NSCoding {
    
    // MARK: Properties
    
    var word: String
    var photo: UIImage?
    var bgColor: UIColor
    
    struct PropertyKey {
        static let wordKey = "name"
        static let photoKey = "photo"
        static let bgColorKey = "bgColor"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("symbols")
    
    
    // MARK: Initialization
    
    init?(word: String, photo: UIImage?, bgColor: UIColor) {
        // Initialize stored properties.
        self.word = word
        self.photo = photo
        self.bgColor = bgColor
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(word, forKey: PropertyKey.wordKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(bgColor, forKey: PropertyKey.bgColorKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let word = aDecoder.decodeObjectForKey(PropertyKey.wordKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as! UIImage
        
        let bgColor = aDecoder.decodeObjectForKey(PropertyKey.bgColorKey) as! UIColor
        
        // Must call designated initializer.
        self.init(word: word, photo: photo, bgColor: bgColor)
    }
    
}