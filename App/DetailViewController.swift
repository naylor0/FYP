//
//  DetailViewController.swift
//  App
//
//  Created by Mark Naylor on 21/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailWord: UITextField!
    @IBOutlet weak var detailTextToSpeak: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var detailRedButton: UIButton!
    @IBOutlet weak var detailYellowButton: UIButton!
    @IBOutlet weak var detailGreenButton: UIButton!
    @IBOutlet weak var detailBlueButton: UIButton!
    @IBOutlet weak var detailOrangeButton: UIButton!
    @IBOutlet weak var detailWhiteButton: UIButton!
    
    var colourArray = [UIButton]()
    var symbol: Symbol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        detailWord.delegate = self
        
        // Set up views if editing an existing Meal.
        if let symbol = symbol {
            navBar.title = symbol.word
            detailWord.text = symbol.word
            detailImage.image = symbol.photo
            //detailTextToSpeak.text = symbol.word
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidSymbolName()
        
        detailBlueButton.layer.borderColor = UIColor.blackColor().CGColor
        detailBlueButton.layer.borderWidth = 0.8
        detailGreenButton.layer.borderColor = UIColor.blackColor().CGColor
        detailGreenButton.layer.borderWidth = 0.8
        detailRedButton.layer.borderColor = UIColor.blackColor().CGColor
        detailRedButton.layer.borderWidth = 0.8
        detailWhiteButton.layer.borderColor = UIColor.blackColor().CGColor
        detailWhiteButton.layer.borderWidth = 0.8
        detailOrangeButton.layer.borderColor = UIColor.blackColor().CGColor
        detailOrangeButton.layer.borderWidth = 0.8
        detailYellowButton.layer.borderColor = UIColor.blackColor().CGColor
        detailYellowButton.layer.borderWidth = 0.8
        colourArray.append(detailRedButton)
        colourArray.append(detailBlueButton)
        colourArray.append(detailGreenButton)
        colourArray.append(detailWhiteButton)
        colourArray.append(detailOrangeButton)
        colourArray.append(detailYellowButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidSymbolName()
        navigationItem.title = textField.text
    }
    
    func checkValidSymbolName() {
        // Disable the Save button if the text field is empty.
        let text = detailWord.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === saveButton {
            let word = detailWord.text
            let image = detailImage.image
            //let speak = detailTextToSpeak.text
            let colour = UIColor.whiteColor()
            
            symbol = Symbol(word: word!, photo: image, bgColor: colour)
        }
        
    }

} // End DetailViewController
