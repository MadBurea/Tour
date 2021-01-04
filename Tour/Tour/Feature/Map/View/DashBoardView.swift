//
//  DashBoardView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import MapKit

// MARK: - View Delegate -
@objc protocol DashBoardDelegate {
    func locationListNavigation(_ sender: UIButton)
    func goToAddTour(_ coordinate: CLLocationCoordinate2D)
}

class DashBoardView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak var delegate: DashBoardDelegate?
    @IBOutlet final private weak var mapView: MKMapView!
    
    // MARK: - Variable -
    final private var tourDetails = [TourDetails]()

    var refreshAnnotations: Bool! {
        didSet {
            setAnnotation()
        }
    }
    
    // MARK: - View Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
}

// MARK: - Prepare View -
private extension DashBoardView {
    
    final private func prepareView() {
        mapView.showsUserLocation = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    final  private func getTour() -> [TourDetails] {
        let viewModel = QueryTour(with: DBManager(persistentContainer: persistance))
        return viewModel.getList(where: nil)
    }
    
    final private func setAnnotation() {
        
        tourDetails = getTour()
        plog(tourDetails)
        
        mapView.removeAnnotations(mapView.annotations)
        
        tourDetails.forEach { (tour) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = tour.coordinate
            annotation.title = tour.title
            annotation.subtitle = tour.descriptions
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - View Action -
private extension DashBoardView {
    
    @IBAction final private func btnListAction(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.locationListNavigation(sender)
    }
    
    @objc final private func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        let details = tourDetails.filter { $0.latitude == coordinate.latitude}
        plog(details)
        
        guard let delegate = delegate else { return }
        delegate.goToAddTour(coordinate)
    }
}

extension DashBoardView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard !annotation.isKind(of: MKUserLocation.self) else {
//            return nil
//        }
//
//        let annotationIdentifier = "AnnotationIdentifier"
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//           // annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            annotationView!.canShowCallout = true
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//
//        annotationView!.image = UIImage(named: "iconList.png")
//
//        return annotationView
//    }
}
