//
//  TourLocationDB.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import CoreData

// MARK: - Download Path -
struct TourLocationDetail {
    var latitude: Double  = 0
    var longitude: Double  = 0
    var time = Date()
}

// MARK: - Convert to storable entity -
extension TourLocationDetail: Entity {
    
    public func toStorable(in context: NSManagedObjectContext, withSuperClass superClass: NSManagedObject?, isMediaUpate: Bool) -> TourLocation? {
        
        let coreDataTour = TourLocation.insertNew(in: context)
        coreDataTour.time = time
        coreDataTour.latitude = latitude
        coreDataTour.longitude = longitude
        
        return coreDataTour
    }
}

// MARK: - Get Modal -
extension TourLocation: Storable {
    
    var primaryKey: String {
        get {
            return time?.description ?? ""
        }
    }
    
    var model: TourLocationDetail {
        get {
            return TourLocationDetail(latitude: latitude,
                                      longitude: longitude,
                                      time: time ?? Date())
        }
    }
}
