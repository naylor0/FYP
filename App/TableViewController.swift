//
//  SplitTableViewController.swift
//  App
//
//  Created by Mark Naylor on 21/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var symbolsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var allSymbols = [Symbol]()
    var allBoards = [Board]()
    var filteredResults = [Symbol]()
    var searchActive : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        allSymbols = loadSymbols()
        allBoards = loadBoards()!

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredResults.count
        }
        return allSymbols.count;
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = TableViewCell()
        if tableView == symbolsList {
            if (searchActive) {
                cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
                cell.word.text = filteredResults[indexPath.row].word
                cell.photo.image = filteredResults[indexPath.row].photo
                cell.colourButton.layer.backgroundColor = filteredResults[indexPath.row].bgColor.CGColor
                cell.colourButton.layer.borderColor = UIColor.blackColor().CGColor
                cell.colourButton.layer.borderWidth = 0.6
                cell.deleteSymbol.tag = indexPath.row
                cell.deleteSymbol.addTarget(self, action: #selector(TableViewController.deleteSymbol(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.addToBoard.tag = indexPath.row
                cell.addToBoard.addTarget(self, action: #selector(TableViewController.addSymbolToBoard(_:)), forControlEvents: UIControlEvents.TouchUpInside)

            } else{
                cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
                cell.word.text = allSymbols[indexPath.row].word
                cell.photo.image = allSymbols[indexPath.row].photo
                cell.colourButton.layer.backgroundColor = allSymbols[indexPath.row].bgColor.CGColor
                cell.colourButton.layer.borderColor = UIColor.blackColor().CGColor
                cell.colourButton.layer.borderWidth = 0.6
                cell.deleteSymbol.tag = indexPath.row
                cell.deleteSymbol.addTarget(self, action: #selector(TableViewController.deleteSymbol(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.addToBoard.tag = indexPath.row
                cell.addToBoard.addTarget(self, action: #selector(TableViewController.addSymbolToBoard(_:)), forControlEvents: UIControlEvents.TouchUpInside)

            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("editSymbol", sender: self)
    }
    
    func deleteSymbol (sender:UIButton) {
        let index = sender.tag
        let refreshAlert = UIAlertController(title: "Delete", message: "Symbol will be removed from library.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
            self.allSymbols.removeAtIndex(index)
            self.symbolsList.reloadData()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete and remove from boards", style: .Default, handler: { (action: UIAlertAction!) in
            self.allSymbols.removeAtIndex(index)
            self.symbolsList.reloadData()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    func addSymbolToBoard (sender:UIButton) {
        let index = sender.tag
        let refreshAlert = UIAlertController(title: "Add To Board", message: "Select board to add to:", preferredStyle: UIAlertControllerStyle.Alert)
        
        for board in allBoards {
            refreshAlert.addAction(UIAlertAction(title: board.name, style: .Default, handler: { (action: UIAlertAction!) in
                board.symbols.append(self.allSymbols[index])
            }))
        }
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredResults = allSymbols.filter({ (symbol) -> Bool in
            let tmp: NSString = symbol.word
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredResults.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.symbolsList.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func saveSymbols() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allSymbols, toFile: Symbol.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        print("Saved symbols")
    }
    
    func saveBoards() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allBoards, toFile: Board.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        print("Saved boards")
    }
    
    func loadSymbols() -> Array<Symbol> {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Symbol.ArchiveURL.path!) as? [Symbol])!
    }
    
    func loadBoards() -> Array<Board>? {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Board.ArchiveURL.path!) as? [Board])!
    }
    
    @IBAction func DismissCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func DismissSave(sender: AnyObject) {
        saveSymbols()
        saveBoards()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editSymbol" {
            
            let index = self.symbolsList.indexPathForSelectedRow! as NSIndexPath
            let viewController:DetailViewController = segue.destinationViewController as! DetailViewController
            viewController.currentSymbol = self.allSymbols[index.row] as Symbol
            self.symbolsList.deselectRowAtIndexPath(index, animated: true)
            
        }
        
    }
    
//    @IBAction func unwindToSymbolsList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                // Update an existing meal.
//                meals[selectedIndexPath.row] = meal
//                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
//            } else {
//                // Add a new meal.
//                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
//                meals.append(meal)
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
//            }
//        }
//    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
