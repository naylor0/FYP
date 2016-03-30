//
//  Settings.swift
//  App
//
//  Created by Mark Naylor on 25/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import Foundation
import UIKit

class Settings: NSObject, NSCoding {
    var name: String
    var readingLevel: Int
    var backgroundColour: UIColor
    var predictionLearning : Bool
    var corpusPrediction: Bool
    var password: Int
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("settings")
    
    struct PropertyKey {
        static let readingLevelKey = "readingAge"
        static let nameKey = "name"
        static let backgroundColourKey = "backgroundColour"
        static let predictionLearningKey = "predictionLearning"
        static let corpusPredictionKey = "corpusPrediction"
        static let passwordKey = "passwordKey"
    }
    
    init?(readingLevel: Int, name: String, backgroundColour: UIColor, predictionLearning: Bool, corpusPrediction: Bool, password: Int) {
        self.readingLevel = readingLevel
        self.name = name
        self.backgroundColour = backgroundColour
        self.predictionLearning = predictionLearning
        self.corpusPrediction = corpusPrediction
        self.password = password
        super.init()
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let readingLevel = aDecoder.decodeObjectForKey(PropertyKey.readingLevelKey) as! Int
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let backgroundColour = aDecoder.decodeObjectForKey(PropertyKey.backgroundColourKey) as! UIColor
        let predictionLearning = aDecoder.decodeBoolForKey(PropertyKey.predictionLearningKey) as Bool
        let corpusPrediction = aDecoder.decodeBoolForKey(PropertyKey.corpusPredictionKey) as Bool
        let password = aDecoder.decodeObjectForKey(PropertyKey.passwordKey) as! Int
        self.init(readingLevel: readingLevel, name: name, backgroundColour: backgroundColour, predictionLearning: predictionLearning, corpusPrediction: corpusPrediction, password: password)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject (readingLevel, forKey: PropertyKey.readingLevelKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(backgroundColour, forKey: PropertyKey.backgroundColourKey)
        aCoder.encodeBool(predictionLearning, forKey: PropertyKey.predictionLearningKey)
        aCoder.encodeBool(corpusPrediction, forKey: PropertyKey.corpusPredictionKey)
        aCoder.encodeObject(password, forKey: PropertyKey.passwordKey)
    }
}