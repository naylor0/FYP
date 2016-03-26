//
//  ComprehensionSelector.swift
//  App
//
//  Created by Mark Naylor on 26/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class ComprehensionSelector: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var selectorView: UITableView!
    
    let levels = ["1 (100 words)", "2 (400 words)", "3 (500 words)", "4 (800 words)", "5 (1000 words)"]
    var readingAge = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indexPath = NSIndexPath(forRow: readingAge - 1, inSection: 0)
        selectorView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    @IBAction func dismissCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SelectorTableCell
        cell.rowtext.text = self.levels[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        readingAge = indexPath.row + 1
        print("Selected row " + indexPath.row.description)
    }
}
