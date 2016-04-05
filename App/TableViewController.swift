//
//  SplitTableViewController.swift
//  App
//
//  Created by Mark Naylor on 21/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var allBoards = [Board]()
    var allSymbols = [Symbol]()
    var filteredResults = [Symbol]()
    var symbolSelected: Symbol?
    var searchActive : Bool = false
    var selectedRow: TableViewCell?
    var dataLoaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        print("trying to load symbols")
        allSymbols = ArchiveAccess.loadSymbols()
        allBoards = ArchiveAccess.loadBoards()!
        print("Loaded data from viewDidLoad")
        dataLoaded = true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft ,UIInterfaceOrientationMask.LandscapeRight]
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
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchActive {
            symbolSelected = filteredResults[indexPath.row]
            performSegueWithIdentifier("EditSymbol", sender: self)
        } else {
            symbolSelected = allSymbols[indexPath.row]
            performSegueWithIdentifier("EditSymbol", sender: self)
        }
        
    }
    // MARK: - Actions
    
    
    func deleteSymbol (sender:UIButton) {
        let index = sender.tag
        let refreshAlert = UIAlertController(title: "Delete", message: "Symbol will be removed from library.", preferredStyle: UIAlertControllerStyle.Alert)
        
        if searchActive {
            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
                self.removeFromDataSource(self.filteredResults[index])
                self.searchActive = false
                self.searchBar.text = ""
                self.tableView.reloadData()
            }))
        } else {
            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
                self.allSymbols.removeAtIndex(index)
                self.tableView.reloadData()
            }))
        }
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    func removeFromDataSource (symbol: Symbol) {
        var count = 0
        for item in allSymbols {
            if item.word == symbol.word {
                allSymbols.removeAtIndex(count)
            }
            count = count + 1
        }
    }
    func updateDataSource (symbol: Symbol) {
        var count = 0
        for item in allSymbols {
            if item.word == symbol.word {
                allSymbols[count] = symbol
            }
            count = count + 1
        }
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
            print("Cancelled adding to board.")
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredResults = allSymbols.filter({ (symbol) -> Bool in
            let tmp: NSString = symbol.word
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredResults.count <= 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    @IBAction func DismissCancel(sender: AnyObject) {
        dataLoaded = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func DismissSave(sender: AnyObject) {
        ArchiveAccess.saveSymbols(allSymbols)
        ArchiveAccess.saveBoards(allBoards)
        dataLoaded = false
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
            print("Symbol passed: " + symbolSelected!.word)
            symbolDetailViewController.symbol = symbolSelected
        } else if segue.identifier == "AddSymbol" {
            print("Adding symbol.")
        }
    }
    
    @IBAction func unwindToSymbolList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DetailViewController, editedSymbol = sourceViewController.symbol {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                if searchActive {
                    updateDataSource(editedSymbol)
                    filteredResults[selectedIndexPath.row] = editedSymbol
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                } else {
                    allSymbols[selectedIndexPath.row] = editedSymbol
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                }
            } else {
                if searchActive {
                    let newIndexPath = NSIndexPath(forRow: allSymbols.count, inSection: 0)
                    allSymbols.append(editedSymbol)
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                } else {
                    let newIndexPath = NSIndexPath(forRow: filteredResults.count, inSection: 0)
                    allSymbols.append(editedSymbol)
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
            }
        }
    }
}
