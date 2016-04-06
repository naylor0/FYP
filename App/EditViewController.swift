//
//  EditViewController.swift
//  App
//
//  Created by Mark Naylor on 21/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var boardCollection: UICollectionView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var currentBoard: Board?
    var settings: Settings?
    var currentBoardPos = 0
    var categories = [Board]()
    var deleteSender = ""
    private var longPressGesture1: UILongPressGestureRecognizer!
    private var longPressGesture2: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(boardCollection)
        self.view.addSubview(categoryCollection)
        
        self.categories = ArchiveAccess.loadBoards()!
        currentBoard = self.categories[0]
        self.settings = ArchiveAccess.loadSettings()
        
        categoryCollection.layer.borderWidth = 1.0
        categoryCollection.layer.borderColor = UIColor.blackColor().CGColor
        boardCollection.layer.borderWidth = 1.0
        boardCollection.layer.borderColor = UIColor.blackColor().CGColor
        
        longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(EditViewController.handleLongGesture1(_:)))
        longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(EditViewController.handleLongGesture2(_:)))
        self.boardCollection.addGestureRecognizer(longPressGesture1)
        self.categoryCollection.addGestureRecognizer(longPressGesture2)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var noCells = 0
        if collectionView == self.boardCollection {
            noCells = self.currentBoard!.symbols.count
        } else if collectionView == self.categoryCollection {
            noCells = self.categories.count
        }
        return noCells
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(0.0, 0.0)
        if collectionView == self.boardCollection {
            size = CGSizeMake((settings?.cellSize)!, (settings?.cellSize)!)
        } else if collectionView == self.categoryCollection {
            size = CGSizeMake(100.0, 100.0)
        }
        return size
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = CollectionViewCell()
        
        if collectionView == self.boardCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.currentBoard!.symbols[indexPath.row].photo
            cell.word?.text = self.currentBoard!.symbols[indexPath.row].word
            cell.backgroundColor = self.currentBoard!.symbols[indexPath.row].bgColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            cell.delete.tag = indexPath.row
            cell.delete.addTarget(self, action: #selector(EditViewController.deleteCell(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        } else if collectionView == self.categoryCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cat", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.categories[indexPath.row].icon.photo
            cell.word?.text = self.categories[indexPath.row].name
            if currentBoard == self.categories[indexPath.row] {
                cell.layer.borderColor = UIColor.blueColor().CGColor
                cell.layer.borderWidth = 2.0
            } else {
                cell.layer.borderColor = UIColor.blackColor().CGColor
                cell.layer.borderWidth = 0.6
            }
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            cell.delete.tag = indexPath.row
            cell.delete.addTarget(self, action: #selector(EditViewController.deleteCat(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.categoryCollection {
            currentBoard = self.categories[indexPath.row]
            currentBoardPos = indexPath.row
            self.categoryCollection.reloadData()
            self.boardCollection.reloadData()
            self.boardCollection.setNeedsDisplay()
        }
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if collectionView == self.boardCollection {
            let temp = currentBoard?.symbols.removeAtIndex(sourceIndexPath.item)
            currentBoard?.symbols.insert(temp!, atIndex: destinationIndexPath.item)
        } else if collectionView == self.categoryCollection {
            let temp = categories.removeAtIndex(sourceIndexPath.item)
            categories.insert(temp, atIndex: destinationIndexPath.item)
        }
    }
    
    func deleteCell (sender:UIButton) {
        let index = sender.tag
        self.currentBoard!.symbols.removeAtIndex(index)
        self.boardCollection.reloadData()
        self.boardCollection.setNeedsDisplay()
        
    }
    func deleteCat (sender:UIButton) {
        let index = sender.tag
        if index == currentBoardPos {
            self.currentBoard!.symbols.removeAll()
            self.boardCollection.reloadData()
            self.boardCollection.setNeedsDisplay()
        }
        self.categories.removeAtIndex(index)
        self.categoryCollection.reloadData()
        self.categoryCollection.setNeedsDisplay()
    }
    
    @IBAction func DismissSaveEdit(sender: AnyObject) {
        ArchiveAccess.saveBoards(self.categories)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func DismissCancelEdit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleLongGesture1(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.boardCollection.indexPathForItemAtPoint(gesture.locationInView(self.boardCollection)) else {
                break
            }
            boardCollection.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            boardCollection.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            boardCollection.endInteractiveMovement()
        default:
            boardCollection.cancelInteractiveMovement()
        }
    }
    func handleLongGesture2(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.categoryCollection.indexPathForItemAtPoint(gesture.locationInView(self.categoryCollection)) else {
                break
            }
            categoryCollection.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            categoryCollection.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            categoryCollection.endInteractiveMovement()
        default:
            categoryCollection.cancelInteractiveMovement()
        }
    }
    @IBAction func addSymbol(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowList", sender: self)
    }
    @IBAction func addBoard(sender: AnyObject) {
        self.performSegueWithIdentifier("AddBoard", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowList" {
            print("Opening popup view")
        }
    }
    
    @IBAction func unwindToSymbolList(sender: UIStoryboardSegue) {
        let sourceViewController = sender.sourceViewController as? AddSymbolController
        let addedSymbols = sourceViewController!.addedSymbols
        if addedSymbols.count > 0 {
            currentBoard?.symbols += addedSymbols
            boardCollection.reloadData()
        }
    }
    
    @IBAction func unwindToBoardList(sender: UIStoryboardSegue) {
        let sourceViewController = sender.sourceViewController as? AddBoardController
        let addedBoards = sourceViewController!.addedBoards
        for board in addedBoards {
            let symbols = [Symbol]()
            categories.append(Board(symbols: symbols, icon: board, name: board.word)!)
        }
        categoryCollection.reloadData()
    }
}
