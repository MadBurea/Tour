//
//  Tour+CoreDataProperties.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//
//

import Foundation
import CoreData


extension Tour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tour> {
        return NSFetchRequest<Tour>(entityName: "Tour")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var filePath: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var color: String?

}
