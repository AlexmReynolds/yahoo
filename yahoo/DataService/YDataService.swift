//
//  YDataService.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import Foundation

class YDataService {
    func getAppSettings() -> YAppSettings {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return YAppSettings()
        }
        var resultInterfaceObject = YAppSettings()
        
        context.performAndWait {
            let results = CoreDataAppSettings.getAll(predicate: nil, context: context)
            if let first = results.first {//only will ever be 1
                resultInterfaceObject = first.interfaceObject()
            }
        }
        return resultInterfaceObject
    }
    
    
    func save(appSettings: YAppSettings) {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return
        }
        
        context.performAndWait {
            if let _settings = CoreDataAppSettings.getAll(context: context).first {
                _settings.updateFrom(interfaceObject: appSettings, context: context)
                do {
                    try context.save()
                } catch {
                    print("save app settings save error \(error.localizedDescription)")
                }
            } else {
                let _ = CoreDataAppSettings.make(interfaceObject: appSettings, context: context)
                do {
                    try context.save()
                } catch {
                    print("save app settings save error \(error.localizedDescription)")
                }
            }
        }
        return
    }
    
    
    func getCompanies() -> [YCompany] {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return []
        }
        var items : [YCompany] = []
        context.performAndWait {
            let all = CoreDataCompany.getAll(context: context)
            for item in all {
                items.append(item.interfaceObject())
            }
        }
        
        return items
    }
    
    func saveCompanies(_ companies: [YCompany]) {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return
        }
        context.performAndWait {
            for item in companies {
                if let _settings = CoreDataCompany.getBySymbol(item.symbol, context: context) {
                    _settings.updateFrom(interfaceObject: item, context: context)
                } else {
                    let _ = CoreDataCompany.make(interfaceObject: item, context: context)
                }
            }
            
            do {
                try context.save()
            } catch {
                print("save gym save error \(error.localizedDescription)")
            }
        }
    }
}
