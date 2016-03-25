//
//  SettingsViewController.swift
//  App
//
//  Created by Mark Naylor on 20/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
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
    
}
