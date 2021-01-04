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
