//
//  LIDownloadDB.swift
//  Tour
//
//  Created by Narendra Pandey on04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Download Path -
struct TourDetails {
    var title = ""
    var descriptions = ""
    var filePath = ""
    var latitude: Double  = 0
    var longitude: Double  = 0
    var color = ""
}

// MARK: - Convert to storable entity -
extension TourDetails: Entity {
    
    public func toStorable(in context: NSManagedObjectContext, withSuperClass superClass: NSManagedObject?, isMediaUpate: Bool) -> Tour? {
        
        let predicate = NSPredicate(format: "self.title = %@", title.lowercased())
        
        let coreDataTour = Tour.getOrCreateSingle(with: predicate, from: context)
        
        coreDataTour.title = title.lowercased()
        coreDataTour.descriptions = descriptions
        coreDataTour.filePath = filePath
        coreDataTour.latitude = latitude
        coreDataTour.longitude = longitude
        coreDataTour.color = UIColor.random().toHexString()

        return coreDataTour
    }
}

// MARK: - Get Modal -
extension Tour: Storable {
    
    var primaryKey: String {
        get {
            return title ?? ""
        }
    }
    
    var model: TourDetails {
        get {
            return TourDetails(title: title ?? "" ,
                               descriptions: descriptions ?? "",
                               filePath: filePath ?? "",
                               latitude: latitude, longitude: longitude)
        }
    }
}

extension TourDetails {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
