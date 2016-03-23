//
//  SplitTableViewController.swift
//  App
//
//  Created by Mark Naylor on 21/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var symbolsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var allSymbols = [Symbol]()
    var allBoards = [Board]()
    var filteredResults = [Symbol]()
    var searchActive : Bool = false
    var selectedRow: TableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        allSymbols = loadSymbols()
        allBoards = loadBoards()!
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
        selectedRow = symbolsList.cellForRowAtIndexPath(indexPath) as! TableViewCell
        performSegueWithIdentifier("EditSymbol", sender: self)
    }
    
    func deleteSymbol (sender:UIButton) {
        let index = sender.tag
        let refreshAlert = UIAlertController(title: "Delete", message: "Symbol will be removed from library.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
            self.allSymbols.removeAtIndex(index)
            self.symbolsList.reloadData()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    // MARK: - Actions
    
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
    
    
    @IBAction func DismissCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func DismissSave(sender: AnyObject) {
        saveSymbols()
        saveBoards()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func newSymbol(sender: AnyObject) {
        performSegueWithIdentifier("AddSymbol", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EditSymbol" {
            print("Editing symbol")
            let symbolDetailViewController = segue.destinationViewController as! DetailViewController
            if let selectedSymbolCell = selectedRow {
                let indexPath = symbolsList.indexPathForCell(selectedSymbolCell)!
                let selectedSymbol = allSymbols[indexPath.row]
                print("Symbol passed: " + selectedSymbol.word)
                symbolDetailViewController.symbol = selectedSymbol
            }
        } else if segue.identifier == "AddSymbol" {
            print("Adding new symbol.")
        }
    }
    
    @IBAction func unwindToSymbolList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DetailViewController, editedSymbol = sourceViewController.symbol {
            if let selectedIndexPath = symbolsList.indexPathForSelectedRow {
                allSymbols[selectedIndexPath.row] = editedSymbol
                symbolsList.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                let newIndexPath = NSIndexPath(forRow: allSymbols.count, inSection: 0)
                allSymbols.append(editedSymbol)
                symbolsList.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    
    // MARK: NSCoding
    
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

}
