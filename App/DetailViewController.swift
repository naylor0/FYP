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
    @IBOutlet weak var colourPicker: ColourControl!
    
    
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
            colourPicker.colour = symbol.bgColor
            detailImage.layer.backgroundColor = symbol.bgColor.CGColor
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidSymbolName()
        
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
            let colour = colourPicker.colour
            
            symbol = Symbol(word: word!, photo: image, bgColor: colour)
        }
        
    }

} // End DetailViewController
