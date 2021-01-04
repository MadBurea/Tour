//
//  DashBoardController.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import MapKit

class DashBoardController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet final private weak var mapView: MKMapView!
    
    // MARK: - View Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc final private func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        goToAddTour(coordinate)
        
        // Add annotation:
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        mapView.addAnnotation(annotation)
    }
}

// MARK: - DashBoard Delegate -
extension DashBoardController: DashBoardDelegate {
    func locationListNavigation(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LocationListController") as? LocationListController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func goToAddTour(_ coordinate: CLLocationCoordinate2D) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EditTourController") as? EditTourController {
            controller.tourFlow = .AddTour(coordinate)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
