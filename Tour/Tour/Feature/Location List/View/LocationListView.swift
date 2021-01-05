//
//  LocationListView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit

// MARK: - View Delegate -
@objc protocol LocationListDelegate {
    func backNavigation()
    func exportLocation()
}

class LocationListView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak var delegate: LocationListDelegate?
    @IBOutlet private weak var stackLocation: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Variable -
    var locationDetails: [TourLocationDetail]! {
        didSet {
            if Thread.isMainThread {
                addLocations(locationDetails)
            }
        }
    }
    
    // MARK: - View Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK: - View Action -
private extension LocationListView {
    
    @IBAction final private func btnBackAction() {
        guard let delegate = delegate else { return }
        delegate.backNavigation()
    }
    
    @IBAction final private func btnExportAction() {
        guard let delegate = delegate else { return }
        delegate.exportLocation()
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
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: false)
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
