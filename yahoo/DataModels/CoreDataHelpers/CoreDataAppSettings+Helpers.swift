//
//  CoreDataAppSettings+Helpers.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//


import Foundation
import CoreData

extension CoreDataAppSettings {
    func updateFrom(interfaceObject: YAppSettings, context: NSManagedObjectContext) {
        self.companyListSortOrder = Int16(interfaceObject.companyListSort.rawValue)
    }
    
    func interfaceObject() -> YAppSettings {
        let obj = YAppSettings()
        obj.companyListSort = YAppSettings.CompanyListSort(rawValue: Int(self.companyListSortOrder)) ?? .name
        return obj
    }
    
    class func make(interfaceObject: YAppSettings, context: NSManagedObjectContext) -> CoreDataAppSettings {
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataAppSettings", in: context)
        let obj = CoreDataAppSettings(entity: entity!, insertInto: context)
        obj.updateFrom(interfaceObject: interfaceObject, context: context)
        return obj
    }
    
    class func getAll(predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [CoreDataAppSettings] {
        do {
            let request : NSFetchRequest<CoreDataAppSettings> = CoreDataAppSettings.fetchRequest()
            request.predicate = predicate
            let results = try context.fetch(request)
            return results
        } catch {
            return []
        }
    }
    
    class func deleteAll(context: NSManagedObjectContext, coordinator: NSPersistentStoreCoordinator) {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = self.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        context.performAndWait {
            do {
                try coordinator.execute(deleteRequest, with: context)
            } catch let error as NSError {
                print("delete all settings error \(error)")
            }
        }

    }
}
