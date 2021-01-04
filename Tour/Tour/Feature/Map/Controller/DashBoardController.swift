//
//  DashBoardController.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit

class DashBoardController: UIViewController {
    
    // MARK: - View Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - DashBoard Delegate -
extension DashBoardController: DashBoardDelegate {
    func locationListNavigation(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LocationListController") as? LocationListController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}