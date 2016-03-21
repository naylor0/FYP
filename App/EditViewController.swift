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
    var categories = [Board]()
    private var longPressGesture: UILongPressGestureRecognizer!
    
    let bgRed = UIColor(netHex:0xFF9999)
    let bgGreen = UIColor(netHex:0xCCFF99)
    let bgYellow = UIColor(netHex: 0xFFFF66)
    let bgWhite = UIColor(netHex: 0xFFFFFF)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(boardCollection)
        self.view.addSubview(categoryCollection)
        
        self.categories = loadBoards()!
        print(categories.count)
        currentBoard = self.categories[0]
        
        categoryCollection.layer.borderWidth = 1.0
        categoryCollection.layer.borderColor = UIColor.blackColor().CGColor
        boardCollection.layer.borderWidth = 1.0
        boardCollection.layer.borderColor = UIColor.blackColor().CGColor
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
        self.boardCollection.addGestureRecognizer(longPressGesture)
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = CollectionViewCell()
        
        if collectionView == self.boardCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.currentBoard!.symbols[indexPath.row].photo
            cell.word?.text = self.currentBoard!.symbols[indexPath.row].word
            cell.backgroundColor = self.currentBoard!.symbols[indexPath.row].bgColor
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            
        } else if collectionView == self.categoryCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cat", forIndexPath: indexPath) as! CollectionViewCell
            cell.image?.image = self.categories[indexPath.row].icon.photo
            cell.word?.text = self.categories[indexPath.row].name
            cell.backgroundColor = bgWhite
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 4
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.categoryCollection {
            currentBoard = self.categories[indexPath.row]
            self.boardCollection.reloadData()
            self.boardCollection.setNeedsDisplay()
        }
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let temp = currentBoard?.symbols.removeAtIndex(sourceIndexPath.item)
        currentBoard?.symbols.insert(temp!, atIndex: destinationIndexPath.item)
    }
    
    func loadBoards() -> Array<Board>? {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(Board.ArchiveURL.path!) as? [Board])!
    }
    
    func saveBoards() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(categories, toFile: Board.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        print("Saved Data")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DismissSaveEdit(sender: AnyObject) {
        saveBoards()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func DismissCancelEdit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
