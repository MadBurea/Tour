//
//  NotificationList.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import UIKit

class NotificationListView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblDate: UILabel!
    @IBOutlet weak private var lblNo: UILabel!
    
    // MARK: - variables -
    final private let format = "dd-MMM-yyyy HH:mm:ss"
    
    var index = 0
    var list: TourLocationDetail! {
        didSet {
            lblTitle.text = "Latitude: \(list.latitude) \nLongitude: \(list.longitude)"
            lblNo.text = "\(index + 1)"
            let updatedDate = list.time.getFormattedDate(format: format)
            lblDate.text = "Updated at: \(updatedDate)"
        }
    }
}
