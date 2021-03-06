//
//  DashBoardController.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import MapKit

class DashBoardController: UIViewController {
    
    // MARK: - View Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMap()
    }
}

// MARK: - Prepare View  -
private extension DashBoardController {
    
    final private func refreshMap() {
        if let view = view as? DashBoardView {
            view.refreshAnnotations = true
        }
    }
}

// MARK: - DashBoard Delegate -
extension DashBoardController: DashBoardDelegate {
    func locationListNavigation() {
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
    
    func viewTour(_ annotation: TourAnnotation) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EditTourController") as? EditTourController {
            controller.tourFlow = .ViewTour(annotation)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
