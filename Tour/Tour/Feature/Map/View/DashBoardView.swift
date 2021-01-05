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
    func viewTour(_ annotation: TourAnnotation)
}

class DashBoardView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak var delegate: DashBoardDelegate?
    @IBOutlet final private weak var mapView: MKMapView!
    
    // MARK: - Variable -
    final private var tourDetails = [TourDetails]()
    final private let annotations = TourAnnotations()
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
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    final  private func getTour() -> [TourDetails] {
        let viewModel = QueryTour(with: DBManager(persistentContainer: persistance))
        return viewModel.getList(where: nil)
    }
    
    final private func setAnnotation() {
        
        tourDetails = getTour()
        mapView.removeAnnotations(mapView.annotations)
        annotations.tours.removeAll()
        
        tourDetails.forEach { (tour) in
            let annotation = TourAnnotation(tour.latitude,
                                            tour.longitude,
                                            title: tour.title,
                                            subtitle: tour.descriptions,
                                            color: tour.color,
                                            filePath: tour.filePath)
            
            annotations.tours.append(annotation)
        }
        mapView.addAnnotations(annotations.tours)
        
        var zoomRect: MKMapRect = MKMapRect.null
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x,
                                      y: annotationPoint.y,
                                      width: 0.5,
                                      height: 0.5)
            zoomRect = zoomRect.union(pointRect)
        }
        mapView.setVisibleMapRect(zoomRect,
                                  edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                                  animated: true)
    }
}

// MARK: - UIGestureRecognizer Delegate -
extension DashBoardView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
