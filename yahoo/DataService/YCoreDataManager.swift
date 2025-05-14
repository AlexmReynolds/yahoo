//
//  YCoreDataManager.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import Foundation
import CoreData

class YCoreDataManager : NSObject {
    static var sharedInstance = YCoreDataManager()
    var mainContext : NSManagedObjectContext!
    var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    var container : NSPersistentContainer!

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.contextDidUpdate(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    func loadContainer(_ container : NSPersistentContainer) {
        self.container = container
        self.mainContext = container.viewContext
        self.persistentStoreCoordinator = container.persistentStoreCoordinator
    }
    
    @objc func contextDidUpdate(notification: Notification) {
        guard let savedContext = notification.object as? NSManagedObjectContext else {
            return
        }
        
        if (self.mainContext == savedContext) {
            return
        }

        if (self.persistentStoreCoordinator != savedContext.persistentStoreCoordinator) {
            return
        }
                
        self.mainContext.perform {
            
            self.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    func makeThrowawayBackgroundQueue() -> NSManagedObjectContext {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        privateMOC.persistentStoreCoordinator = self.persistentStoreCoordinator
        return privateMOC
    }
    
}
