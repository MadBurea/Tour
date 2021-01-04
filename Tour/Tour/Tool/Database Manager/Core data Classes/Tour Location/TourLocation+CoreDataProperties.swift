//
//  TourLocation+CoreDataProperties.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//
//

import Foundation
import CoreData


extension TourLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TourLocation> {
        return NSFetchRequest<TourLocation>(entityName: "TourLocation")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var time: Date?

}
