//
//  DataModel.swift
//  App
//
//  Created by Mark Naylor on 24/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.

import Foundation

protocol DataModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}


class DataModel: NSObject, NSURLSessionDataDelegate {
    
    //properties
    
    weak var delegate: DataModelProtocol!
    
    var data : NSMutableData = NSMutableData()
    
    // this will be changed to the path where service.php lives
    let urlPath: String = "prepict.cloudapp.net/bigrams.php"
    func downloadItems() {
        
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(url)
        
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data);
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            self.parseJSON()
        }
        
    }
    
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do {
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let bigrams: NSMutableArray = NSMutableArray()
        
        for(var i = 0; i < jsonResult.count; i++) {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let bigram = BigramModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let word1 = jsonElement["word1"] as? String, let word2 = jsonElement["word2"] as? String {
            
                bigram.word1 = word1
                bigram.word2 = word2
                
            }
            
            bigrams.addObject(bigram)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.delegate.itemsDownloaded(bigrams)
            
        })
    }
}