//
//  SettingsViewController.swift
//  App
//
//  Created by Mark Naylor on 20/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, DataModelProtocol {
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var libraryButton: UIButton!
    
    @IBOutlet weak var comprehensionView: UIView!
    @IBOutlet weak var comprehensionButton: UIButton!
    
    @IBOutlet weak var predictionView: UIView!
    @IBOutlet weak var historySwitch: UISwitch!
    @IBOutlet weak var corpusSwitch: UISwitch!
    
    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var colourButton: UIButton!
    
    // Testing data connection
    var feedItems = [BigramModel]()
    
    var settings: Settings?
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft ,UIInterfaceOrientationMask.LandscapeRight]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editView.layer.cornerRadius = 6
        libraryView.layer.cornerRadius = 6
        comprehensionView.layer.cornerRadius = 6
        predictionView.layer.cornerRadius = 6
        colourView.layer.cornerRadius = 6
        
        let myFilePath = Settings.ArchiveURL.path!
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            self.settings = loadSettings()
            print("Loaded settings from archive")
        } else {
            self.settings = loadSampleSettings()
            print("Loaded sample settings")
            saveSettings()
        }
        
        historySwitch.on = (settings?.predictionLearning)!
        corpusSwitch.on = (settings?.corpusPrediction)!
        historySwitch.addTarget(self, action: #selector(SettingsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        corpusSwitch.addTarget(self, action: #selector(SettingsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        let hasConnection = Reachability.isConnectedToNetwork()
        if hasConnection {
            let dataModel = DataModel()
            dataModel.delegate = self
            let stringToSend = "readingAge=" + (settings?.readingLevel.description)!
            dataModel.downloadItems(stringToSend)
        }

    }
    
    // Handle UISwitch change of value
    func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.on
        if mySwitch == corpusSwitch {
            settings?.corpusPrediction = value
        } else if mySwitch == historySwitch {
            settings?.predictionLearning = value
        }
        
    }
    
    @IBAction func DismissView(sender: AnyObject) {
        saveSettings()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveSettings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(settings!, toFile: Settings.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save settings...")
        }
        print("Saved settings")
    }
    
    func loadSettings() -> Settings {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Settings.ArchiveURL.path!) as? Settings)!
    }
    
    func loadSampleSettings() -> Settings {
        return Settings(readingLevel: 5, name: "Sophie", backgroundColour: UIColor.darkGrayColor(), predictionLearning: true, corpusPrediction: true)!
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items as! [BigramModel]
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Corpus", inManagedObjectContext:managedContext)
        let newRow = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        for item in feedItems {
            newRow.setValue(item.word1, forKey: "word1")
            newRow.setValue(item.word2, forKey: "word2")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func unwindToComprehensionSelector(sender: UIStoryboardSegue) {
        let sourceViewController = sender.sourceViewController as? ComprehensionSelector
        settings?.readingLevel = sourceViewController!.readingAge
    }
    @IBAction func changeLevel(sender: AnyObject) {
        performSegueWithIdentifier("editLevel", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editLevel" {
            let editLevelViewController = segue.destinationViewController as! ComprehensionSelector
            editLevelViewController.readingAge = (settings?.readingLevel)!
        }
    }
    
}
