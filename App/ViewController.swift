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
    var settings: Settings?
    
    // Outlets for collection views used for boards, their symbols and the current sentence
    @IBOutlet weak var boardCollection: UICollectionView!
    @IBOutlet weak var sentenceCollection: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    // Set up speech synth for speeking words when symbols are tapped
    let synth = AVSpeechSynthesizer()
    var speech = AVSpeechUtterance(string: "")
    
    override func viewWillAppear(animated: Bool) {
        if (ArchiveAccess.checkForFile("boards")) {
            self.categories = ArchiveAccess.loadBoards()!
            print(categories.count.description + " loaded boards from archive for home")
        } else {
            self.categories = ArchiveAccess.loadSampleBoards()!
            print("Loaded sample boards for home")
            ArchiveAccess.saveBoards(self.categories)
        }
        currentBoard = self.categories[0]
        self.boardCollection.reloadData()
        self.boardCollection.setNeedsDisplay()
        self.categoryCollection.reloadData()
        self.categoryCollection.setNeedsDisplay()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft ,UIInterfaceOrientationMask.LandscapeRight]
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
        
        if (ArchiveAccess.checkForFile("boards")) {
            self.categories = ArchiveAccess.loadBoards()!
            print(categories.count.description + " loaded boards from archive for home")
        } else {
            self.categories = ArchiveAccess.loadSampleBoards()!
            print("Loaded sample boards for home")
            ArchiveAccess.saveBoards(self.categories)
        }
        currentBoard = self.categories[0]
        
        if (ArchiveAccess.checkForFile("symbols")) {
            self.allSymbols = ArchiveAccess.loadSymbols()
            print(self.allSymbols.count.description + " symbols loaded from archive for home")
        } else {
            self.allSymbols = ArchiveAccess.loadSampleSymbols()
            print("Loaded sample symbols for home")
            ArchiveAccess.saveSymbols(self.allSymbols)
        }
        
        if (ArchiveAccess.checkForFile("settings")) {
            self.settings = ArchiveAccess.loadSettings()
        } else {
            settings = ArchiveAccess.loadSampleSettings()
            ArchiveAccess.saveSettings(self.settings!)
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
            //cell.layer.shadowColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            
        } else if collectionView == self.categoryCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cat", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.categories[indexPath.row].icon.photo
            cell.word?.text = self.categories[indexPath.row].name
            cell.backgroundColor = UIColor.whiteColor()
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
    
    

    @IBAction func speakSentence(sender: AnyObject) {
        for part in sentence {
            self.speech = AVSpeechUtterance(string: part.word)
            self.speech.rate = 0.5
            self.synth.speakUtterance(speech)
        }
    }
    
    @IBAction func deleteSentence(sender: AnyObject) {
        generateBigrams(sentence)
        sentence.removeAll()
        self.sentenceCollection.reloadData()
        self.sentenceCollection.setNeedsDisplay()
    }
    
    func generateBigrams(sentence: Array<Symbol>) {
        var insert = [BigramModel]()
        if sentence.count > 1 {
            for (i, item) in sentence.enumerate() {
                if sentence.indices.contains(i + 1) {
                    insert.append(BigramModel(word1:item.word, word2: sentence[i + 1].word))
                }
            }
        }
        DataAccess.insertToCoreData(insert, table: "History")
    } // End generate bigrams method

} // End View Controller