//
//  NumberCell.swift
//  Demo
//
//  Created by MAC215 on 22/12/20.
//

import UIKit

class NumberCell: UICollectionViewCell {
    
    @IBOutlet final private weak var labelNumber: UILabel!
    
    var number: Int! {
        didSet {
            labelNumber.text = "\(number ?? 0)"
        }
    }
    
    var showSelected: Bool! {
        didSet {
            contentView.backgroundColor = showSelected ? .red : .white
        }
    }
}

extension NumberCell : ReusableView, NibLoadableView { }
