//
//  DataController.swift
//  AdventureCalls
//
//  Created by Shirley on 5/31/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import Foundation
import CoreData

// MARK: DataController

class DataController {
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    // MARK: Initializer
    
    init(modelName:String) {
        
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    // MARK: load - Load data stores
    
    func load(completion: (() -> Void)? = nil) {
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            
            guard error == nil else {
                
                fatalError(error!.localizedDescription)
            }
            
            self.autoSaveViewContext()
            completion?()
        }
    }
}

// MARK: Helpers

extension DataController {
    
    // MARK: autoSaveViewContext - autosave view context
    
    func autoSaveViewContext(interval: TimeInterval = 30) {
        
        print("autosaving")
        guard interval > 0 else {
            
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            
            print("hasChanges")
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            
            self.autoSaveViewContext(interval: interval)
        }
    }
}
