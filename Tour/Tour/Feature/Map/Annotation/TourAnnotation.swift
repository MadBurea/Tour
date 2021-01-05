//
//  TourAnnotation.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import MapKit

class TourAnnotation: MKPointAnnotation {
    
    // MARK: - Variable -
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
    var color: String?
    var filePath: String?

    // MARK: - Init -
    init(_ latitude: CLLocationDegrees,_
            longitude: CLLocationDegrees,
         title: String,
         subtitle: String,
         color: String,
         filePath: String) {
        super.init()
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = title
        self.subtitle = subtitle
        self.color = color
        self.filePath = filePath
    }
}
