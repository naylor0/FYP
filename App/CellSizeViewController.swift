//
//  CellSizeViewController.swift
//  App
//
//  Created by Mark Naylor on 06/04/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class CellSizeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let rowText = ["5 x 3 (15 Cells)", "6 x 4 (24 Cells)", "9 x 5 (45 Cells)"]
    let sizes = [150.0, 100.0, 80.0] as [CGFloat]
    var size: CGFloat = 0.0
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        var row = 0
        for (i, s) in sizes.enumerate() {
            if size == s {
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
        return rowText.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.rowText[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        size = sizes[indexPath.row]
    }
    @IBAction func dismissCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
