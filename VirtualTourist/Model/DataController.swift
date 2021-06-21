//
//  DataController.swift
//  VirtualTourist
//
//  Created by Ion Ceban on 6/15/21.
//

import UIKit
import CoreData

class DataController {
    
    static let shared = DataController(modelName: "VirtualTourist")
    let modelName: String
    
    init(modelName:String) {
        self.modelName = modelName
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Core Data stack

       lazy var persistentContainer: NSPersistentContainer = {
          
           let container = NSPersistentContainer(name: "VirtualTourist")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                  
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       // MARK: - Core Data Saving support

       func save () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }

    
}


