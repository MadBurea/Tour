//
//  LocationListView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit

// MARK: - View Delegate -
@objc protocol LocationListDelegate {
    func backNavigation(_ sender: UIButton)
}

class LocationListView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak var delegate: LocationListDelegate?
    
    // MARK: - View Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK: - View Action -
private extension LocationListView {
    
    @IBAction final private func btnBackAction(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.backNavigation(sender)
    }
}
