//
//  ColourTableController.swift
//  App
//
//  Created by Mark Naylor on 31/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class ColourTableController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var colours: [UIColor] = [UIColor.darkGrayColor(), UIColor.whiteColor(), UIColor.blackColor(), UIColor.brownColor(), UIColor.grayColor(), UIColor.purpleColor(), UIColor.magentaColor()]
    var colourNames: [String] = ["Dark grey", "White", "Black", "Brown", "Grey", "Purple", "Magenta"]
    var backgroundColour: UIColor?
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        var row = 0
        for (i, c) in colours.enumerate() {
            if c.toHexString() == backgroundColour?.toHexString() {
                row = i
            }
        }
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        table.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colours.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ColourTableCell
        cell.colourName.text = self.colourNames[indexPath.row]
        cell.colourButton.layer.backgroundColor = self.colours[indexPath.row].CGColor
        cell.colourButton.layer.borderColor = UIColor.blackColor().CGColor
        cell.colourButton.layer.borderWidth = 1.0
        return cell
    }
    
    @IBAction func dismissCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        backgroundColour = colours[indexPath.row + 1]
    }
}
