//
//  CoreDataManager.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 17..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class CoreDataManager: NSObject {
    static let sharedCoreDataManager = CoreDataManager()
    
    func addFavoriteData(fullName: String, coinData: Any) {
        self.removeFavoriteData(fullName: fullName)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(fullName, forKey: "fullName")
        user.setValue(coinData, forKey: "coinData")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error addFavoriteData : \(error.userInfo)")
        }
    }
    
    func removeFavoriteData(fullName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "fullName = %@", fullName)

        do {
            let fetch = try managedContext.fetch(fetchRequest)
            if fetch.count <= 0 {
                return
            }
            
            let targetObject = fetch[0] as! NSManagedObject
            managedContext.delete(targetObject)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error addFavoriteData : \(error.userInfo)")
            }

        } catch let error as NSError {
            print("Error not find target object : \(error.userInfo)")
        }
    }
    
    func selectFavoriteDatas() -> [(Any)]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count <= 0 {
                return nil
            }
            
            var results = Array<Any>()
            for data in result as! [NSManagedObject] {
                let coinData = data.value(forKey: "coinData") as Any
                results.append(coinData)
            }
            
            return results
            
        } catch let error as NSError {
            print("Error not select objects : \(error.userInfo)")
        }
        
        return nil
    }

    func selectFavoriteData(fullName: String) -> Any? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "fullName  = %@", fullName)
        
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            if fetch.count <= 0 {
                return nil
            }
            
            let targetObject = fetch[0] as! NSManagedObject
            let coinData = targetObject.value(forKey: "coinData") as Any
            
            return coinData

        } catch let error as NSError {
            print("Error not find target object : \(error.userInfo)")
        }
        
        return nil
    }
}
