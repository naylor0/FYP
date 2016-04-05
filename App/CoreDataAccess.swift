//
//  CoreDataAccess.swift
//  App
//
//  Created by Mark Naylor on 27/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class CoreDataAccess {
    
    class func insertToCoreData(items: Array<BigramModel>, table: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName(table, inManagedObjectContext:managedContext)
        for item in items {
            let newRow = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            newRow.setValue(item.word1.lowercaseString, forKey: "word1")
            newRow.setValue(item.word2.lowercaseString, forKey: "word2")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    class func clearCoreData(table: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
            print("Core data deleted")
        } catch let error as NSError {
            print("Detele all data in \(table) error : \(error) \(error.userInfo)")
        }
    }
    class func selectCoreDataCorpus(word: String) -> Array<Corpus> {
        var results = [Corpus]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Corpus")
        fetchRequest.predicate = NSPredicate(format: "word1 == %@", word.lowercaseString)
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [Corpus]
        } catch {
            fatalError("Failed to fetch corpus \(error)")
        }
        return results
    }
    class func selectCoreDataHistory(word: String) -> Array<History> {
        var results = [History]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "word1 == %@", word.lowercaseString)
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [History]
        } catch {
            fatalError("Failed to fetch history \(error)")
        }
        print(results.description)
        return results
    }
}
