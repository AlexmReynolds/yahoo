//
//  CoreDataCompany+Helpers.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import Foundation
import CoreData

extension CoreDataCompany {
    func updateFrom(interfaceObject: YCompany, context: NSManagedObjectContext) {
        self.name = interfaceObject.name
        self.symbol = interfaceObject.symbol
        self.raw = Int64(interfaceObject.marketCap.value)
        self.fmt = interfaceObject.marketCap.formattedString
        self.longFmt = interfaceObject.marketCap.longFormattedString
    }
    
    func interfaceObject() -> YCompany {
        let mrkCap = YCompanyMarketCap(formattedString: self.fmt ?? "", longFormattedString: self.longFmt ?? "", value: Int(self.raw))
        let obj = YCompany(marketCap: mrkCap, name: self.name ?? "", symbol: self.symbol ?? "")
        return obj
    }
    
    class func make(interfaceObject: YCompany, context: NSManagedObjectContext) -> CoreDataCompany {
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataCompany", in: context)
        let obj = CoreDataCompany(entity: entity!, insertInto: context)
        obj.updateFrom(interfaceObject: interfaceObject, context: context)
        return obj
    }
    
    class func getAll(predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [CoreDataCompany] {
        do {
            let request : NSFetchRequest<CoreDataCompany> = CoreDataCompany.fetchRequest()
            request.predicate = predicate
            let results = try context.fetch(request)
            return results
        } catch {
            return []
        }
    }
    
    class func getBySymbol(_ symbol : String, context: NSManagedObjectContext) -> CoreDataCompany? {
        do {
            let fetchRequest : NSFetchRequest<CoreDataCompany> = CoreDataCompany.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "symbol == %@",symbol)
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            return nil
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
