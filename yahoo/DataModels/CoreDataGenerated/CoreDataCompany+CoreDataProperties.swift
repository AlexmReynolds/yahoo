//
//  CoreDataCompany+CoreDataProperties.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
//

import Foundation
import CoreData


extension CoreDataCompany {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataCompany> {
        return NSFetchRequest<CoreDataCompany>(entityName: "CoreDataCompany")
    }

    @NSManaged public var raw: Int64
    @NSManaged public var fmt: String?
    @NSManaged public var longFmt: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?

}

extension CoreDataCompany : Identifiable {

}
