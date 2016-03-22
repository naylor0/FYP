//
//  DetailViewController.swift
//  App
//
//  Created by Mark Naylor on 21/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailWord: UITextField!
    @IBOutlet weak var detailTextToSpeak: UITextField!
    
    @IBOutlet weak var detailRedButton: UIButton!
    @IBOutlet weak var detailYellowButton: UIButton!
    @IBOutlet weak var detailGreenButton: UIButton!
    @IBOutlet weak var detailBlueButton: UIButton!
    @IBOutlet weak var detailOrangeButton: UIButton!
    @IBOutlet weak var detailWhiteButton: UIButton!
    var colourArray = [UIButton]()
    var currentSymbol: Symbol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if currentSymbol != nil {
            self.title = self.currentSymbol!.word
            self.detailImage.image = self.currentSymbol?.photo
            self.detailWord.text = self.currentSymbol?.word
            for button in colourArray {
                if button.backgroundColor == currentSymbol?.bgColor {
                    button.highlighted == true
                }
                else {
                    button.highlighted == false
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveSymbolDetail(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
