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

    
    func getCompanies(offset: Int, sortBySymbol: Bool) -> [YCompany] {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return []
        }
        var items : [YCompany] = []
        context.performAndWait {
            let all = CoreDataCompany.getAll(sortBySymbol: sortBySymbol, fetchOffset: offset, context: context)
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
                //TODO: This is only called from API and api doesn't have isFavorite so make sure whatever is stored is persisted and ignore API Val
                if let _settings = CoreDataCompany.getBySymbol(item.symbol, context: context) {
                    let isFavorite = _settings.isFavorite
                    _settings.updateFrom(interfaceObject: item, context: context)
                    _settings.isFavorite = isFavorite
                } else {
                    let _ = CoreDataCompany.make(interfaceObject: item, context: context)
                }
            }
            
            do {
                try context.save()
            } catch {
                print("save copanies save error \(error.localizedDescription)")
            }
        }
    }
    
    func getFavorites() -> [YCompany] {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return []
        }
        var items : [YCompany] = []
        context.performAndWait {
            let all = CoreDataCompany.getFavorites(context: context)
            for item in all {
                items.append(item.interfaceObject())
            }
        }
        
        return items
    }
    
    func saveCompany(_ company: YCompany) -> Void {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return
        }
        context.performAndWait {
            if let _company = CoreDataCompany.getBySymbol(company.symbol, context: context) {
                _company.updateFrom(interfaceObject: company, context: context)
            }
        }
        do {
            try context.save()
        } catch {
            print("save company save error \(error.localizedDescription)")
        }
    }
    
    func getCompany(symbol: String) -> YCompany? {
        var _context = YCoreDataManager.sharedInstance.mainContext
        if (!Thread.isMainThread) {
            _context = YCoreDataManager.sharedInstance.makeThrowawayBackgroundQueue()
        }
        guard let context = _context else {
            return nil
        }
        var result: YCompany?
        context.performAndWait {
            result = CoreDataCompany.getBySymbol(symbol, context: context)?.interfaceObject()
        }
        return result
    }
}
