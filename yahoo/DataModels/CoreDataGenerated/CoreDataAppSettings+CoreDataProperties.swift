//
//  CoreDataAppSettings+CoreDataProperties.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
//

import Foundation
import CoreData


extension CoreDataAppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataAppSettings> {
        return NSFetchRequest<CoreDataAppSettings>(entityName: "CoreDataAppSettings")
    }

    @NSManaged public var companyListSortOrder: Int16

}

extension CoreDataAppSettings : Identifiable {

}
