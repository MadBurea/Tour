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
    @IBOutlet private weak var stackLocation: UIStackView!
    
    // MARK: - Variable -
    var locationDetails: [TourLocationDetail]! {
        didSet {
            addLocations(locationDetails)
        }
    }
    
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

// MARK: - Add Notification -
private extension LocationListView {
    
    final private func addLocations(_ list: [TourLocationDetail]) {
        removeNoData()
        
        list.enumerated().forEach { (listing) in
            let locationView = getXIB(type: NotificationListView.self)
            locationView.index = listing.offset
            locationView.list = listing.element
            stackLocation.addArrangedSubview(locationView)
        }
        if list.isEmpty { addNoDataView() }
    }
    
    final private func removeNoData() {
        for view in stackLocation.arrangedSubviews { view.removeFromSuperview() }
    }
    
    final private func addNoDataView() {
        removeNoData()
        let externalSegment  = getXIB(type: NoDataView.self)
        externalSegment.noDataType = .notification
        stackLocation.addArrangedSubview(externalSegment)
    }
}
