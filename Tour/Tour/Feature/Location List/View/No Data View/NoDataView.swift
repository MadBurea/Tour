//
//  NoDataView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import UIKit

enum NoDataType {
    case notification
}

class NoDataView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet weak private var imgNoData: UIImageView!
    @IBOutlet weak private var lblNoData: UILabel!
    
    // MARK: - Variables -
    var noDataType: NoDataType! {
        didSet {
            
            switch noDataType {
            
            case .notification:
                imgNoData.image = UIImage(named: "icon_No_Notify")
                lblNoData.text = "No Location Tracking data Yet"
                
            case .none:
                break
                
            }
        }
    }
}
