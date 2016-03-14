//
//  ViewController.swift
//  App
//
//  Created by Mark Naylor on 10/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var categories = [Board]()
    var sentence = [Symbol]()
    var currentBoard: Board?
    
    @IBOutlet weak var boardCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let bgRed = UIColor(netHex:0xFF9999)
    let bgGreen = UIColor(netHex:0xCCFF99)
    let bgYellow = UIColor(netHex: 0xFFFF66)
    let bgWhite = UIColor(netHex: 0xFFFFFF)
    
    let synth = AVSpeechSynthesizer()
    var speech = AVSpeechUtterance(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(boardCollection)
        self.view.addSubview(categoryCollection)
        self.view.addSubview(sentenceCollection)
        
        boardCollection.layer.cornerRadius = 6
        categoryCollection.layer.cornerRadius = 6
        sentenceCollection.layer.cornerRadius = 6
        
        boardCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        sentenceCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        categoryCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        
        if self.loadSymbols() != nil {
            if let savedBoard = self.loadSymbols() {
                currentBoard!.symbols += savedBoard
                print("loaded from file")
            }
        }
        else {
            ("not loaded from file")
            // Load the sample data.
            self.categories = self.loadSampleCategories()!
            currentBoard = categories[0]
        }

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
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 6
            
        } else if collectionView == self.categoryCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cat", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.categories[indexPath.row].icon.photo
            cell.word?.text = self.categories[indexPath.row].name
            cell.backgroundColor = bgWhite
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 6
            
        } else if collectionView == self.sentenceCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sen", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.sentence[indexPath.row].photo
            cell.word?.text = self.sentence[indexPath.row].word
            cell.backgroundColor = self.sentence[indexPath.row].bgColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 6
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.boardCollection {
            sentence.append(self.currentBoard!.symbols[indexPath.row])
            self.speech = AVSpeechUtterance(string: self.currentBoard!.symbols[indexPath.row].word)
            self.speech.rate = 0.3
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
    
    func saveSymbols() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(currentBoard!.symbols, toFile: Symbol.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save symbols...")
        }
    }
    
    func loadSymbols() -> [Symbol]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Symbol.ArchiveURL.path!) as? [Symbol]
    }
    
    
    func loadSampleCategories() -> [Board]? {
        var sampleCategories = [Board]()
        let symbols = [Symbol]()
        
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "talk", photo: UIImage(named: "talk"), bgColor: bgWhite)!, name: "talk")!)
        sampleCategories[0].loadSampleBoard()
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "news", photo: UIImage(named: "news"), bgColor: bgWhite)!, name: "news")!)
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "activities", photo: UIImage(named: "activities"), bgColor: bgWhite)!, name: "activities")!)
        sampleCategories[2].loadSampleBoard()
        sampleCategories.append(Board(symbols: symbols, icon: Symbol(word: "weather", photo: UIImage(named: "weather"), bgColor: bgWhite)!, name: "weather")!)
        sampleCategories[3].loadSampleBoard()
        
        return sampleCategories
    }


}

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