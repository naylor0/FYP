//
//  ViewController.swift
//  App
//
//  Created by Mark Naylor on 10/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, DataModelProtocol {
    
    var categories = [Board]()
    var sentence = [Symbol]()
    var suggestions = [Symbol]()
    var currentBoard: Board?
    var allSymbols = [Symbol]()
    var settings: Settings?
    var hasBoard: Bool = false
    
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
            if self.categories.count == 0 {
                self.categories = ArchiveAccess.loadSampleBoards()!
                ArchiveAccess.saveBoards(self.categories)
            }
        } else {
            self.categories = ArchiveAccess.loadSampleBoards()!
            ArchiveAccess.saveBoards(self.categories)
        }
        if categories.count > 0 {
            currentBoard = self.categories[0]
        }
        if (ArchiveAccess.checkForFile("settings")) {
            self.settings = ArchiveAccess.loadSettings()
            print("Loaded settings")
        } else {
            settings = ArchiveAccess.loadSampleSettings()
            ArchiveAccess.saveSettings(self.settings!)
        }
        self.boardCollection.backgroundColor = settings?.backgroundColour
        self.suggestionCollection.backgroundColor = settings?.backgroundColour
        self.categoryCollection.backgroundColor = settings?.backgroundColour
        self.boardCollection.reloadData()
        self.boardCollection.setNeedsDisplay()
        self.categoryCollection.reloadData()
        self.categoryCollection.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.speech.voice = AVSpeechSynthesisVoice(language: "en-IE")
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(boardCollection)
        self.view.addSubview(categoryCollection)
        self.view.addSubview(sentenceCollection)
        self.view.addSubview(suggestionCollection)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.speakSentence(_:)))
        tap.delegate = self
        sentenceCollection.addGestureRecognizer(tap)
        
        
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
        if categories.count > 0 {
            currentBoard = self.categories[0]
        }
        
        if (ArchiveAccess.checkForFile("symbols")) {
            self.allSymbols = ArchiveAccess.loadSymbols()
            print(self.allSymbols.count.description + " symbols loaded from archive for home")
        } else {
            self.allSymbols = ArchiveAccess.loadSampleSymbols()
            print("Loaded sample symbols for home: " + allSymbols.count.description)
            ArchiveAccess.saveSymbols(self.allSymbols)
        }
        
        if (ArchiveAccess.checkForFile("settings")) {
            self.settings = ArchiveAccess.loadSettings()
        } else {
            settings = ArchiveAccess.loadSampleSettings()
            ArchiveAccess.saveSettings(self.settings!)
        }
        if !((settings?.dataDownloaded)!) && (settings?.corpusPrediction)! {
            let hasConnection = Reachability.isConnectedToNetwork()
            if hasConnection {
                let dataModel = DataModel()
                dataModel.delegate = self
                let stringToSend = "readingAge=" + (settings?.readingLevel.description)!
                CoreDataAccess.clearCoreData("Corpus")
                dataModel.downloadItems(stringToSend)
            }

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloaded(items: NSArray) {
        var feedItems = items as! [BigramModel]
        CoreDataAccess.insertToCoreData(feedItems, table: "Corpus")
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
    
    func collectionView(collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                          sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(0.0, 0.0)
        if collectionView == self.boardCollection {
            size = CGSizeMake((settings?.cellSize)!, (settings?.cellSize)!)
        } else if collectionView == self.categoryCollection {
            size = CGSizeMake(100.0, 100.0)
        } else if collectionView == self.sentenceCollection {
            size = CGSizeMake(100.0, 100.0)
        } else if collectionView == self.suggestionCollection {
            size = CGSizeMake(100.0, 100.0)
        }
        return size

        
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
            self.speech = AVSpeechUtterance(string: self.categories[indexPath.row].name)
            self.speech.rate = 0.5
            self.synth.speakUtterance(speech)
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
        if ((settings?.predictionLearning) != nil) {
            generateBigrams(sentence)
        }
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
        CoreDataAccess.insertToCoreData(insert, table: "History")
    } // End generate bigrams method
    
    func generateSuggestion(word: String)
    {
        suggestions.removeAll()
        var results1 = [Corpus]()
        if ((settings?.corpusPrediction) == true) {
            results1 = CoreDataAccess.selectCoreDataCorpus(word)
        }
        var results2 = [History]()
        if ((settings?.predictionLearning) == true) {
            results2 = CoreDataAccess.selectCoreDataHistory(word)
        }
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
                        object.count = object.count! + 1
                    }
                }
            }
            resultsSet = resultsSet.sort { $0.count > $1.count }
            
            for item in resultsSet {
                let i = getSymbol(item.word2)
                if i > -1 {
                    if !suggestions.contains(allSymbols[i!]) {
                        suggestions.append(allSymbols[i!])
                    }
                }
            }
            suggestionCollection.reloadData()
            suggestionCollection.setNeedsDisplay()

        }
    }
    
    @IBAction func launchSettings (sender: AnyObject) {
        performSegueWithIdentifier("showSettings", sender: self)
    }
    
    func getSymbol(word: String) -> Int? {
        var result: Int = -1
        for (sym, i) in allSymbols.enumerate() {
            if i.word == word{
                result = sym
                break
            }
        }
        return result
    }

} // End View Controller