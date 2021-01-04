//
//  DashBoardView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit

// MARK: - View Delegate -
@objc protocol DashBoardDelegate {
    func locationListNavigation(_ sender: UIButton)
}

class DashBoardView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak var delegate: DashBoardDelegate?
    
    // MARK: - View Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK: - View Action -
private extension DashBoardView {
    
    @IBAction final private func btnListAction(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.locationListNavigation(sender)
    }
}
