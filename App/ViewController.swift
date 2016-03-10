//
//  ViewController.swift
//  App
//
//  Created by Mark Naylor on 10/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var boardCollection: UICollectionView!
    
    var boardWordArray = ["hi", "how", "is", "weather", "good", "bad"]
    var boardImageArray = [UIImage(named: "hi"), UIImage(named: "how"), UIImage(named: "is"), UIImage(named: "weather"), UIImage(named: "good"), UIImage(named: "bad") ]
    var sentenceWordArray: [String] = []
    var sentenceImageArray: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boardImageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("board", forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView?.image = self.boardImageArray[indexPath.row]
        cell.imageTitle?.text = self.boardWordArray[indexPath.row]
        
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 6;
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        sentenceImageArray.append(self.boardImageArray[indexPath.row]!)
        sentenceWordArray.append(self.boardWordArray[indexPath.row])
    }


}

