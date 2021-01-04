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
        // Do any additional setup after loading the view.
    }
}

// MARK: - List Delegate -
extension LocationListController: LocationListDelegate {
    func backNavigation(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
