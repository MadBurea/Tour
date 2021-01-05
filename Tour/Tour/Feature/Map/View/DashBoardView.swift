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
    func locationListNavigation()
    func goToAddTour(_ coordinate: CLLocationCoordinate2D)
    func viewTour(_ annotation: TourAnnotation)
}

class DashBoardView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak var delegate: DashBoardDelegate?
    @IBOutlet final private weak var mapView: MKMapView!
    
    // MARK: - Variable -
    final private var tourDetails = [TourDetails]()
    final private let identifier = "Tourism"

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
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleTap))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    final  private func getTour() -> [TourDetails] {
        let viewModel = QueryTour(with: DBManager(persistentContainer: persistance))
        return viewModel.getList(where: nil)
    }
    
    final private func setAnnotation() {
        
        tourDetails = getTour()
        mapView.removeAnnotations(mapView.annotations)
        
        let tourAnnotations = tourDetails.reduce(into: [TourAnnotation]()) { (result, tour) in
            let annotation = TourAnnotation(tour.latitude,
                                            tour.longitude,
                                            title: tour.title,
                                            subtitle: tour.descriptions,
                                            color: tour.color,
                                            filePath: tour.filePath)
            
            result.append(annotation)
        }
        
        mapView.addAnnotations(tourAnnotations)
        
        var zoomRect: MKMapRect = MKMapRect.null
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x,
                                      y: annotationPoint.y,
                                      width: 0.1,
                                      height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        mapView.setVisibleMapRect(zoomRect,
                                  edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                                  animated: true)
    }
}

// MARK: - View Action -
private extension DashBoardView {
    
    @IBAction final private func btnListAction(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.locationListNavigation()
    }
    
    @objc final private func handleTap(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
         if gestureRecognizer.state == .ended {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            guard let delegate = delegate else { return }
            delegate.goToAddTour(coordinate)
        }
    }
}

extension DashBoardView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        if let eventAnnotation = view.annotation as? TourAnnotation {
            plog(eventAnnotation)
            guard let delegate = delegate else { return }
            delegate.viewTour(eventAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = MKMarkerAnnotationView()
        guard let annotation = annotation as? TourAnnotation else { return nil }
        
        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.markerTintColor = annotation.color?.toUIColor()
        annotationView.glyphImage = UIImage(named: "tour")
        annotationView.glyphTintColor = .red
        annotationView.clusteringIdentifier = identifier
        return annotationView
    }
}
