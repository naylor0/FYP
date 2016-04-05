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
    
    var feedItems = [BigramModel]()
    var settings: Settings?
    
    override func shouldAutorotate() -> Bool {
        return true
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
        
        if (ArchiveAccess.checkForFile("settings")) {
            self.settings = ArchiveAccess.loadSettings()
            print("Loaded settings from archive")
        } else {
            self.settings = ArchiveAccess.loadSampleSettings()
            print("Loaded sample settings")
            ArchiveAccess.saveSettings(settings!)
        }
        if !(settings?.dataDownloaded)! {
            let hasConnection = Reachability.isConnectedToNetwork()
            if hasConnection {
                let dataModel = DataModel()
                dataModel.delegate = self
                let stringToSend = "readingAge=" + (settings?.readingLevel.description)!
                dataModel.downloadItems(stringToSend)
                self.settings?.dataDownloaded = true
            }
            
        }
        
        historySwitch.on = (settings?.predictionLearning)!
        corpusSwitch.on = (settings?.corpusPrediction)!
        historySwitch.addTarget(self, action: #selector(SettingsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        corpusSwitch.addTarget(self, action: #selector(SettingsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

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
        ArchiveAccess.saveSettings(settings!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSettings() -> Settings {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Settings.ArchiveURL.path!) as? Settings)!
    }
    @IBAction func deleteCorpus(sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Clear Corpus Data", message: "Are you sure you want to clear the data?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action: UIAlertAction!) in
            CoreDataAccess.clearCoreData("Corpus")
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancelled deleting corpus data")
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func deleteHistory(sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Clear User History Data", message: "Are you sure you want to clear the data?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action: UIAlertAction!) in
            CoreDataAccess.clearCoreData("History")
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancelled deleting corpus data")
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items as! [BigramModel]
        CoreDataAccess.insertToCoreData(feedItems, table: "Corpus")
    }
    @IBAction func pickBGColour(sender: AnyObject) {
        performSegueWithIdentifier("chooseColour", sender: self)
    }
    
    @IBAction func unwindToComprehensionSelector(sender: UIStoryboardSegue) {
        let sourceViewController = sender.sourceViewController as? ComprehensionSelector
        if settings?.readingLevel != sourceViewController?.readingAge {
            let hasConnection = Reachability.isConnectedToNetwork()
            if hasConnection {
                let dataModel = DataModel()
                dataModel.delegate = self
                let stringToSend = "readingAge=" + (settings?.readingLevel.description)!
                CoreDataAccess.clearCoreData("Corpus")
                dataModel.downloadItems(stringToSend)
            }
            settings?.readingLevel = sourceViewController!.readingAge
        }
    }
    @IBAction func unwindToColourSelector(sender: UIStoryboardSegue) {
        let sourceViewController = sender.sourceViewController as? ColourTableController
        if settings?.backgroundColour != sourceViewController?.backgroundColour {
            settings?.backgroundColour = sourceViewController!.backgroundColour!
        }
    }
    @IBAction func changeLevel(sender: AnyObject) {
        performSegueWithIdentifier("editLevel", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editLevel" {
            let editLevelViewController = segue.destinationViewController as! ComprehensionSelector
            editLevelViewController.readingAge = (settings?.readingLevel)!
        } else if segue.identifier == "chooseColour" {
            let colourViewController = segue.destinationViewController as! ColourTableController
            colourViewController.backgroundColour = settings?.backgroundColour
        }
    }
    
}
