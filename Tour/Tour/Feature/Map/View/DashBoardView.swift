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
    
    // MARK: - View Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        mapView.addGestureRecognizer(gestureRecognizer)
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
        guard let delegate = delegate else { return }
        delegate.goToAddTour(coordinate)
    }
}
