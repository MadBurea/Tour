//
//  LocationListController.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit

class LocationListController: UIViewController {
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
}

// MARK: - List Delegate -
extension LocationListController: LocationListDelegate {
    func backNavigation(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Prepare View -
extension LocationListController {
    
    final private func prepareView() {
        refreshLocation()
        updateNewLocation()
    }
    
    final private func getTourLocation() -> [TourLocationDetail] {
        let viewModel = QueryTourLocation(with: DBManager(persistentContainer: persistance))
        return viewModel.getList(where: nil)
    }
    
    @IBAction final private func refreshLocation() {
        if let view = view as? LocationListView {
            view.locationDetails = getTourLocation()
        }
    }
    
    final private func updateNewLocation() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: TSLocationManger.LOCATION_TRACKING),
                                                  object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.refreshLocation),
            name: NSNotification.Name(rawValue: TSLocationManger.LOCATION_TRACKING),
            object: nil)
    }
}
