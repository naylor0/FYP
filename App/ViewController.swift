//
//  ViewController.swift
//  App
//
//  Created by Mark Naylor on 10/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var categories = [Board]()
    var sentence = [Symbol]()
    var currentBoard: Board?
    var allSymbols = [Symbol]()
    
    @IBOutlet weak var boardCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let bgRed = UIColor(netHex:0xFFCCCC)
    let bgGreen = UIColor(netHex:0xCCFF99)
    let bgYellow = UIColor(netHex: 0xFFFF66)
    let bgWhite = UIColor(netHex: 0xFFFFFF)
    let bgOrange = UIColor(netHex: 0xFFCC66)
    let bgBlue = UIColor(netHex: 0x99CCFF)
    
    let synth = AVSpeechSynthesizer()
    var speech = AVSpeechUtterance(string: "")
    
    override func viewWillAppear(animated: Bool) {
        let myFilePath = Board.ArchiveURL.path!
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            self.categories = loadBoards()!
            print(categories.count.description + " boards loaded from archive for homescreen")
        }
        currentBoard = self.categories[0]
        self.boardCollection.reloadData()
        self.boardCollection.setNeedsDisplay()
        self.categoryCollection.reloadData()
        self.categoryCollection.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(boardCollection)
        self.view.addSubview(categoryCollection)
        self.view.addSubview(sentenceCollection)
        
        categoryCollection.layer.borderWidth = 1.0
        categoryCollection.layer.borderColor = UIColor.blackColor().CGColor
        sentenceCollection.layer.borderWidth = 1.0
        sentenceCollection.layer.borderColor = UIColor.blackColor().CGColor
        boardCollection.layer.borderWidth = 1.0
        boardCollection.layer.borderColor = UIColor.blackColor().CGColor
        
        boardCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        sentenceCollection.layer.backgroundColor = UIColor.whiteColor().CGColor
        categoryCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        var myFilePath = Board.ArchiveURL.path!
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            self.categories = loadBoards()!
            print(categories.count.description + " loaded boards from archive for home")
        } else {
            self.categories = loadSampleBoards()!
            print("Loaded sample boards for home")
            saveBoards()
        }
        currentBoard = self.categories[0]
        
        myFilePath = Symbol.ArchiveURL.path!
        if (manager.fileExistsAtPath(myFilePath)) {
            self.allSymbols = loadSymbols()
            print(self.allSymbols.count.description + " symbols loaded from archive for home")
        } else {
            loadSampleSymbols()
            print("Loaded sample symbols for home")
            saveSymbols()
        }
        currentBoard = self.categories[0]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var noCells = 0
        if collectionView == self.boardCollection {
            noCells = self.currentBoard!.symbols.count
        } else if collectionView == self.categoryCollection {
            noCells = self.categories.count
        } else if collectionView == self.sentenceCollection {
            noCells = self.sentence.count
        }
        return noCells
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = CollectionViewCell()
        
        if collectionView == self.boardCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.currentBoard!.symbols[indexPath.row].photo
            cell.word?.text = self.currentBoard!.symbols[indexPath.row].word
            cell.backgroundColor = self.currentBoard!.symbols[indexPath.row].bgColor
            //cell.layer.shadowColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            
        } else if collectionView == self.categoryCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cat", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.categories[indexPath.row].icon.photo
            cell.word?.text = self.categories[indexPath.row].name
            cell.backgroundColor = bgWhite
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            
        } else if collectionView == self.sentenceCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sen", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.sentence[indexPath.row].photo
            cell.word?.text = self.sentence[indexPath.row].word
            cell.backgroundColor = self.sentence[indexPath.row].bgColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.boardCollection {
            sentence.append(self.currentBoard!.symbols[indexPath.row])
            self.speech = AVSpeechUtterance(string: self.currentBoard!.symbols[indexPath.row].word)
            self.speech.rate = 0.4
            self.synth.speakUtterance(speech)
            self.sentenceCollection.reloadData()
            self.sentenceCollection.setNeedsDisplay()
        }
        else if collectionView == self.categoryCollection {
            currentBoard = self.categories[indexPath.row]
            self.boardCollection.reloadData()
            self.boardCollection.setNeedsDisplay()
        }
    }
    
    func saveBoards() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(categories, toFile: Board.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        print("Saved boards from homescreen")
    }
    
    func saveSymbols() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allSymbols, toFile: Symbol.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        print("Saved symbols from homescreen")
    }
    
    func loadSymbols() -> Array<Symbol> {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Symbol.ArchiveURL.path!) as? [Symbol])!
    }
    
    func loadBoards() -> Array<Board>? {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Board.ArchiveURL.path!) as? [Board])!
    }
    
    func preloadedSymbols(word: String) ->Symbol {
        return Symbol(word: word, photo: UIImage(named: word), bgColor: bgWhite)!
    }
    
    
    func loadSampleBoards() -> [Board]? {
        var sampleCategories = [Board]()
        let symbols = [Symbol]()
        
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "talk", photo: UIImage(named: "talk"), bgColor: bgWhite)!, name: "talk")!)
        sampleCategories[0].loadSampleBoard()
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "news", photo: UIImage(named: "news"), bgColor: bgWhite)!, name: "news")!)
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "activities", photo: UIImage(named: "activities"), bgColor: bgWhite)!, name: "activities")!)
        sampleCategories[2].loadSampleBoard()
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "weather", photo: UIImage(named: "weather"), bgColor: bgWhite)!, name: "weather")!)
        sampleCategories[3].loadSampleBoard()
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "food", photo: UIImage(named: "food"), bgColor: bgWhite)!, name: "food")!)
        sampleCategories[4].loadSampleBoard()
        return sampleCategories
    }

    @IBAction func speakSentence(sender: AnyObject) {
        for part in sentence {
            self.speech = AVSpeechUtterance(string: part.word)
            self.speech.rate = 0.5
            self.synth.speakUtterance(speech)
        }
    }
    
    @IBAction func deleteSentence(sender: AnyObject) {
        sentence.removeAll()
        self.sentenceCollection.reloadData()
        self.sentenceCollection.setNeedsDisplay()
    }
    
    
    func loadSampleSymbols() {
        allSymbols.append(Symbol(word: "activities", photo: UIImage(named: "activities"), bgColor: bgWhite)!)
        allSymbols.append(Symbol(word: "again", photo: UIImage(named: "again"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "around", photo: UIImage(named: "around"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "bad", photo: UIImage(named: "bad"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "big", photo: UIImage(named: "big"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "bye", photo: UIImage(named: "bye"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "colors", photo: UIImage(named: "colors"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "come", photo: UIImage(named: "come"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "delete", photo: UIImage(named: "delete"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "do you", photo: UIImage(named: "do you"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "do", photo: UIImage(named: "do"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "down", photo: UIImage(named: "down"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "finished", photo: UIImage(named: "finished"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "food", photo: UIImage(named: "food"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "forward", photo: UIImage(named: "forward"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "funny", photo: UIImage(named: "funny"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "go away", photo: UIImage(named: "go away"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "go", photo: UIImage(named: "go"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "good", photo: UIImage(named: "good"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "have", photo: UIImage(named: "have"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "he", photo: UIImage(named: "he"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "hello", photo: UIImage(named: "hello"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "help", photo: UIImage(named: "help"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "hi", photo: UIImage(named: "hi"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "how are you", photo: UIImage(named: "how are you"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "how long", photo: UIImage(named: "how long"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "how", photo: UIImage(named: "how"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "i am", photo: UIImage(named: "i am"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "i", photo: UIImage(named: "i"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "in", photo: UIImage(named: "in"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "is", photo: UIImage(named: "is"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "it", photo: UIImage(named: "it"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "jump", photo: UIImage(named: "jump"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "left", photo: UIImage(named: "left"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "less", photo: UIImage(named: "less"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "like", photo: UIImage(named: "like"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "make", photo: UIImage(named: "make"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "me", photo: UIImage(named: "me"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "more", photo: UIImage(named: "more"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "my", photo: UIImage(named: "my"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "news", photo: UIImage(named: "news"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "next", photo: UIImage(named: "next"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "not", photo: UIImage(named: "not"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "off", photo: UIImage(named: "off"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "on", photo: UIImage(named: "on"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "out", photo: UIImage(named: "out"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "people", photo: UIImage(named: "people"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "places", photo: UIImage(named: "places"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "play", photo: UIImage(named: "play"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "put down", photo: UIImage(named: "put down"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "right", photo: UIImage(named: "right"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "run", photo: UIImage(named: "run"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "put down", photo: UIImage(named: "put down"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "school", photo: UIImage(named: "school"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "settings", photo: UIImage(named: "settings"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "small", photo: UIImage(named: "small"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "speak", photo: UIImage(named: "speak"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "stop", photo: UIImage(named: "stop"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "talk", photo: UIImage(named: "talk"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "there", photo: UIImage(named: "there"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "think", photo: UIImage(named: "think"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "turn", photo: UIImage(named: "turn"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "up", photo: UIImage(named: "up"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "walk", photo: UIImage(named: "walk"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "watch", photo: UIImage(named: "watch"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "weather", photo: UIImage(named: "weather"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "what", photo: UIImage(named: "what"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "where", photo: UIImage(named: "where"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "who", photo: UIImage(named: "who"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "why", photo: UIImage(named: "why"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "yes", photo: UIImage(named: "yes"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "you", photo: UIImage(named: "you"), bgColor: bgGreen)!)
        allSymbols.append(Symbol(word: "yours", photo: UIImage(named: "yours"), bgColor: bgGreen)!)
    }
    

} // End View Controller

// Taken from: http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
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