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
    var items = [NSManagedObject]()
    
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
        
        loadAppData()
        if categories.count != 0 {
            currentBoard = categories[0]
            print("Data loaded from DB.")
        }
        else {
            // Load the sample data.
            self.categories = self.loadSampleCategories()!
            currentBoard = categories[0]
            print("Sample data loaded.")
            saveAppData(categories)
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
    
    func deleteAppBoards() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "BoardItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try appDel.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: context)
            print("Boards deleted")
        } catch let error as NSError {
            // TODO: handle the error
        }
    }
    
    func saveAppData(categories: Array<Board>) {
        // Retrieve context from delegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        // Add item to context
        let entity = NSEntityDescription.entityForName("BoardItem", inManagedObjectContext: context)
        
        for board in categories {
            var newBoard = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
            newBoard.setValue(board.icon.word, forKey: "icon")
            newBoard.setValue(board.name, forKey: "name")
            
            do {
                try context.save()
                print(board.name + " saved")
            }
            catch {
                print("Error saving data")
            }
        }
        
    }
    
    func loadAppData() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        do {
            let request = NSFetchRequest(entityName: "BoardItem")
            let results = try context.executeFetchRequest(request)
            print(results.count)
            if results.count > 0 {
                for result in results as! [BoardItem] {
                    var name = result.valueForKey("name")!
                    var icon = result.valueForKey("icon")!
                    print((name as! String) + (icon as! String))
                }
            }
            
        }
        catch {
            print("Error fetching data")
        }
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