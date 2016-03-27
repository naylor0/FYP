//
//  DataAccess.swift
//  App
//
//  Created by Mark Naylor on 27/03/2016.
//  Copyright © 2016 Mark Naylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class DataAccess {
    
    class func insertToCoreData(items: Array<BigramModel>, table: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName(table, inManagedObjectContext:managedContext)
        let newRow = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        for item in items {
            newRow.setValue(item.word1, forKey: "word1")
            newRow.setValue(item.word2, forKey: "word2")
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
    class func selectCoreData(word: String, table: String) -> Array<BigramModel> {
        var results = [BigramModel]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.predicate = NSPredicate(format: "word1 == %@", word)
        do {
            results = try managedContext.executeFetchRequest(fetchRequest) as! [BigramModel]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return results
    }
}
