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
        return Settings(readingLevel: 5, name: "Sophie", backgroundColour: UIColor.darkGrayColor(), predictionLearning: true, corpusPrediction: true, password: 0, dataDownloaded: false)!
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
        
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "talk", photo: UIImage(named: "talk"), bgColor: UIColor.whiteColor())!, name: "talk", cellSize: 100)!)
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "news", photo: UIImage(named: "news"), bgColor: UIColor.whiteColor())!, name: "news", cellSize: 100)!)
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "activities", photo: UIImage(named: "activities"), bgColor: UIColor.whiteColor())!, name: "activities", cellSize: 100)!)
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "weather", photo: UIImage(named: "weather"), bgColor: UIColor.whiteColor())!, name: "weather", cellSize: 100)!)
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "food", photo: UIImage(named: "food"), bgColor: UIColor.whiteColor())!, name: "food", cellSize: 100)!)
        return sampleCategories
    }
    
    class func loadSampleBoard() -> Array<Symbol> {
        let bgRed = UIColor(netHex:0xFFCCCC)
        let bgGreen = UIColor(netHex:0xCCFF99)
        let bgYellow = UIColor(netHex: 0xFFFF66)
        let bgWhite = UIColor(netHex: 0xFFFFFF)
        let bgOrange = UIColor(netHex: 0xFFCC66)
        let bgBlue = UIColor(netHex: 0x99CCFF)
        
        var symbols = [Symbol]()
        symbols.append(Symbol(word: "hi", photo: UIImage(named: "hi"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "hello", photo: UIImage(named: "hello"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "how", photo: UIImage(named: "how"), bgColor: bgGreen)!)
        symbols.append(Symbol(word: "is", photo: UIImage(named: "is"), bgColor: bgGreen)!)
        symbols.append(Symbol(word: "weather", photo: UIImage(named: "weather"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "good", photo: UIImage(named: "good"), bgColor: bgRed)!)
        symbols.append(Symbol(word: "bad", photo: UIImage(named: "bad"), bgColor: bgRed)!)
        return symbols
    }
    
    class func loadSampleSymbols() -> Array<Symbol> {
        let bgRed = UIColor(netHex:0xFFCCCC)
        let bgGreen = UIColor(netHex:0xCCFF99)
        let bgYellow = UIColor(netHex: 0xFFFF66)
        let bgWhite = UIColor(netHex: 0xFFFFFF)
        let bgOrange = UIColor(netHex: 0xFFCC66)
        let bgBlue = UIColor(netHex: 0x99CCFF)
        
        var allSymbols = [Symbol]()
        
        print("Loading samples")
        let myFileURL = NSBundle.mainBundle().URLForResource("images", withExtension: "txt")!
        let myText = try! String(contentsOfURL: myFileURL, encoding: NSUTF8StringEncoding)
        let myStrings = myText.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        for obj in myStrings {
            allSymbols.append(Symbol(word: obj, photo: UIImage(named: obj), bgColor: bgWhite)!)
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