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
    var suggestions = [Symbol]()
    var currentBoard: Board?
    var allSymbols = [Symbol]()
    var settings: Settings?
    
    // Outlets for collection views used for boards, their symbols and the current sentence
    @IBOutlet weak var suggestionCollection: UICollectionView!
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
        self.view.addSubview(suggestionCollection)
        
        categoryCollection.layer.borderWidth = 1.0
        categoryCollection.layer.borderColor = UIColor.blackColor().CGColor
        sentenceCollection.layer.borderWidth = 1.0
        sentenceCollection.layer.borderColor = UIColor.blackColor().CGColor
        boardCollection.layer.borderWidth = 1.0
        boardCollection.layer.borderColor = UIColor.blackColor().CGColor
        suggestionCollection.layer.borderWidth = 1.0
        suggestionCollection.layer.borderColor = UIColor.blackColor().CGColor
        
        boardCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        sentenceCollection.layer.backgroundColor = UIColor.whiteColor().CGColor
        categoryCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        suggestionCollection.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        
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
        } else if collectionView == self.suggestionCollection {
            noCells = self.suggestions.count
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
            cell.layer.cornerRadius = 4
        } else if collectionView == self.categoryCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cat", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.categories[indexPath.row].icon.photo
            cell.word?.text = self.categories[indexPath.row].name
            if currentBoard == self.categories[indexPath.row] {
                cell.layer.borderColor = UIColor.blueColor().CGColor
                cell.layer.borderWidth = 2.0
            } else {
                cell.layer.borderWidth = 0.2
                cell.layer.borderColor = UIColor.blackColor().CGColor
            }
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
        } else if collectionView == self.sentenceCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sen", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.sentence[indexPath.row].photo
            cell.word?.text = self.sentence[indexPath.row].word
            cell.backgroundColor = self.sentence[indexPath.row].bgColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
        } else if collectionView == self.suggestionCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sug", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.suggestions[indexPath.row].photo
            cell.word?.text = self.suggestions[indexPath.row].word
            cell.backgroundColor = self.suggestions[indexPath.row].bgColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.boardCollection {
            sentence.append(self.currentBoard!.symbols[indexPath.row])
            generateSuggestion((self.sentence.last?.word)!)
            self.speech = AVSpeechUtterance(string: self.currentBoard!.symbols[indexPath.row].word)
            self.speech.rate = 0.4
            self.synth.speakUtterance(speech)
            self.sentenceCollection.reloadData()
            self.sentenceCollection.setNeedsDisplay()
            self.suggestionCollection.reloadData()
            self.suggestionCollection.setNeedsDisplay()
        } else if collectionView == self.categoryCollection {
            currentBoard = self.categories[indexPath.row]
            self.categoryCollection.reloadData()
            self.boardCollection.reloadData()
            self.boardCollection.setNeedsDisplay()
        } else if collectionView == self.suggestionCollection {
            sentence.append(self.suggestions[indexPath.row])
            self.speech = AVSpeechUtterance(string: self.suggestions[indexPath.row].word)
            self.speech.rate = 0.4
            self.synth.speakUtterance(speech)
            generateSuggestion((self.sentence.last?.word)!)
            self.sentenceCollection.reloadData()
            self.sentenceCollection.setNeedsDisplay()
            self.suggestionCollection.reloadData()
            self.suggestionCollection.setNeedsDisplay()
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
        suggestions.removeAll()
        suggestionCollection.reloadData()
        self.sentenceCollection.reloadData()
        self.sentenceCollection.setNeedsDisplay()
    }
    
    func generateBigrams(sentence: Array<Symbol>) {
        var insert = [BigramModel]()
        if sentence.count > 1 {
            for (i, item) in sentence.enumerate() {
                if i != sentence.endIndex - 1 {
                    insert.append(BigramModel(word1:item.word, word2: sentence[i + 1].word))
                }
            }
        }
        DataAccess.insertToCoreData(insert, table: "History")
    } // End generate bigrams method
    
    func generateSuggestion(word: String)
    {
        suggestions.removeAll()
        let results1 = DataAccess.selectCoreDataCorpus(word)
        let results2 = DataAccess.selectCoreDataHistory(word)
        var resultsSet = [BigramModel]()
        if results1.count > 0 || results2.count > 0 {
            for item in results1 {
                resultsSet.append(BigramModel(word1: item.word1!, word2: item.word2!))
            }
            for item in results2 {
                resultsSet.append(BigramModel(word1: item.word1!, word2: item.word2!))
            }
            for object in resultsSet {
                for j in resultsSet {
                    if object.word2.lowercaseString == j.word2.lowercaseString && object != j {
                        object.count = object.count + 1
                    }
                }
            }
            resultsSet = resultsSet.sort { $0.count > $1.count }
            
            for item in resultsSet {
                if let i = getSymbol(item.word2) {
                    if !suggestions.contains(i) {
                        suggestions.append(i)
                    }
                }
            }
            suggestionCollection.reloadData()
            suggestionCollection.setNeedsDisplay()

        }
    }
    
    func getSymbol(word: String) -> Symbol? {
        var result: Symbol?
        for sym in allSymbols {
            if sym.word == word{
                result = sym
            }
        }
        return result!
    }

} // End View Controller