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
    var symbolWords = ["activities", "again", "around", "bad", "big", "bye", "colors", "come", "delete", "do you", "do", "down", "finished", "food", "forward", "funny", "games", "go away", "go", "good", "have", "he", "hello", "help", "here", "hi", "how are you", "how long", "how", "i am", "i", "in", "is", "it", "jump", "left", "less", "like", "make", "me", "more", "my", "news", "next", "not", "off", "on", "out", "people", "places", "play", "put down", "right", "run", "school", "see", "settings", "she", "small", "speak", "stop", "talk", "there", "think", "turn", "up", "walk", "want", "watch", "weather", "what", "where", "who", "why", "yes", "you", "yours"];
    var allSymbols = [Symbol]()
    
    @IBOutlet weak var boardCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let bgRed = UIColor(netHex:0xFF9999)
    let bgGreen = UIColor(netHex:0xCCFF99)
    let bgYellow = UIColor(netHex: 0xFFFF66)
    let bgWhite = UIColor(netHex: 0xFFFFFF)
    
    let synth = AVSpeechSynthesizer()
    var speech = AVSpeechUtterance(string: "")
    
    override func viewWillAppear(animated: Bool) {
        let myFilePath = Board.ArchiveURL.path!
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            self.categories = loadBoards()!
            print("Loaded from archive")
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
        
        for symbol in symbolWords {
            allSymbols.append(preloadedSymbols(symbol))
        }
        
        let myFilePath = Board.ArchiveURL.path!
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            self.categories = loadBoards()!
            print("Loaded from archive")
        } else {
            self.categories = loadSampleBoards()!
            print("Loaded sample boards")
            saveBoards()
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
        print("Saved Data")
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
}