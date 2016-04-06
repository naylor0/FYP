//
//  ArchiveAccess.swift
//  App
//
//  Created by Mark Naylor on 27/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import Foundation
import UIKit

public class ArchiveAccess {
    
    class func checkForFile(fileName: String) -> Bool {
        let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let myFilePath = DocumentsDirectory.URLByAppendingPathComponent(fileName).path
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath!)) {
            return true
        } else {
            return false
        }
    }
    
    class func saveSettings(settings: Settings) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(settings, toFile: Settings.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save settings...")
        }
        print("Saved settings")
    }
    
    class func loadSettings() -> Settings {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Settings.ArchiveURL.path!) as? Settings)!
    }
    
    class func loadSampleSettings() -> Settings {
        return Settings(readingLevel: 5, name: "Sophie", backgroundColour: UIColor.darkGrayColor(), predictionLearning: true, corpusPrediction: true, cellSize: 100.0, dataDownloaded: false)!
    }
    
    class func saveBoards(categories: Array<Board>) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(categories, toFile: Board.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save boards")
        }
        print("Saved boards from homescreen")
    }
    
    class func saveSymbols(allSymbols: Array<Symbol>) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allSymbols, toFile: Symbol.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save symbols")
        }
        print("Saved symbols")
    }
    
    class func loadSymbols() -> Array<Symbol> {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Symbol.ArchiveURL.path!) as? [Symbol])!
    }
    
    class func loadBoards() -> Array<Board>? {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Board.ArchiveURL.path!) as? [Board])!
    }
    
    class func loadSampleBoards() -> [Board]? {
        var sampleCategories = [Board]()
        let symbols = ArchiveAccess.loadSampleBoard()
        
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "talk", photo: UIImage(named: "talk"), bgColor: UIColor.whiteColor())!, name: "talk")!)
        return sampleCategories
    }
    
    class func loadSampleBoard() -> Array<Symbol> {
        let symbols = [Symbol]()
        return symbols
    }
    
    class func tagWord(word:String) -> UIColor {
        
        let bgYellow = UIColor(netHex: 0xFFFF7F)
        let bgWhite = UIColor(netHex: 0xFFFFFF)
        let bgOrange = UIColor(netHex: 0xFFA500)
        let bgBlue = UIColor(netHex: 0x99CCFF)
        var colour: UIColor = bgWhite
        
        let options: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .JoinNames]
        let schemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        tagger.string = word
        tagger.enumerateTagsInRange(NSMakeRange(0, (word as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
            if tag == "Noun" {
            colour = bgOrange
            } else if tag == "Verb" {
                colour = bgBlue
            } else if tag == "Pronoun" {
                colour = bgYellow
            } else {
                colour = bgWhite
            }
        }
        return colour
    }
    
    
    class func loadSampleSymbols() -> Array<Symbol> {
        var allSymbols = [Symbol]()
        
        print("Loading samples")
        let myFileURL = NSBundle.mainBundle().URLForResource("images", withExtension: "txt")!
        let myText = try! String(contentsOfURL: myFileURL, encoding: NSUTF8StringEncoding)
        let myStrings = myText.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        for obj in myStrings {
            let colour = ArchiveAccess.tagWord(obj)
            allSymbols.append(Symbol(word: obj, photo: UIImage(named: obj), bgColor: colour)!)
        }
        
        return allSymbols
    }
}

// Taken from: http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
// Returns a UIColor object when passed a hex value
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}