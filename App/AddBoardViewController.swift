//
//  AddBoardViewController.swift
//  App
//
//  Created by Mark Naylor on 30/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

//
//  AddBoardController.swift
//  App
//
//  Created by Mark Naylor on 24/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class AddBoardController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var boardsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var allSymbols = [Symbol]()
    var toAdd = [Symbol]()
    var addedBoards = [Symbol]()
    var filteredResults = [Symbol]()
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        allSymbols = ArchiveAccess.loadSymbols()
    }
    
    // MARK: - Table data source methods
    
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
        var cell = AddTableViewCell()
        if (searchActive) {
            cell = boardsTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddTableViewCell
            cell.word.text = filteredResults[indexPath.row].word
            cell.photo.image = filteredResults[indexPath.row].photo
            cell.addButton.tag = indexPath.row
            cell.addButton.addTarget(self, action: #selector(AddBoardController.addBoard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.layer.backgroundColor = filteredResults[indexPath.row].bgColor.CGColor
            
        } else{
            cell = boardsTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddTableViewCell
            cell.word.text = allSymbols[indexPath.row].word
            cell.photo.image = allSymbols[indexPath.row].photo
            cell.addButton.tag = indexPath.row
            cell.addButton.addTarget(self, action: #selector(AddBoardController.addBoard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.layer.backgroundColor = allSymbols[indexPath.row].bgColor.CGColor
        }
        return cell
    }
    
    // MARK: - Actions
    
    func addBoard (sender:UIButton) {
        let index = sender.tag
        if(searchActive) {
            if sender.enabled {
                sender.enabled = false
            }
            toAdd.append(filteredResults[index])
        } else {
            if sender.enabled {
                sender.enabled = false
            }
            toAdd.append(allSymbols[index])
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === saveButton {
            for symbol in toAdd {
                addedBoards.append(symbol)
            }
        }
        
    }
    
    // MARK: - Search bar functionality
    
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
        self.boardsTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        self.boardsTable.reloadData()
    }
    
}
