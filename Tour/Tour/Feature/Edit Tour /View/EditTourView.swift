//
//  EditTourView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import MapKit

struct VideoFile {
    var fileName = ""
    var filePath = ""
}

// MARK: - View Delegate -
@objc protocol EditTourDelegate {
    func attachVideo(_ view: EditTourView)
    func backNavigation(_ view: EditTourView)
}

class EditTourView: UIView {
    
    // MARK: - Outlets -
    @IBOutlet final weak private var textFieldTitle: UITextField!
    @IBOutlet final weak private var textViewTitle : UITextView!
    @IBOutlet final weak private var addVideoButton: UIButton!
    @IBOutlet weak var delegate: EditTourDelegate?
    @IBOutlet final weak private var lblFileName: UILabel!
    @IBOutlet final weak private var lblUploadVideo : UILabel!
    @IBOutlet final weak private var iconClose : UIImageView!
    @IBOutlet final weak private var uploadView : UIView!
    
    // MARK: - Constant -
    final private let tourTilteError = "Please enter tour title"
    final private let tourVideoError = "Please select tour video"
    final private let tourSuccess = "Tour created successfully"
    final private let alertTitle = "Alert"
    final private let ok = "Ok"
    final private var filePath = ""
    final private var latitude: Double = 0
    final private var longitude: Double = 0
    
    var tourFlow: TourFlow! {
        didSet {
            setTour()
        }
    }
    
    var videoName: VideoFile! {
        didSet {
            filePath = videoName.filePath
            lblFileName.isHidden = false
            lblFileName.text = videoName.fileName
            lblUploadVideo.isHidden = true
            iconClose.isHidden = false
        }
    }
    
    // MARK: - View Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK: - View Action -
private extension EditTourView {
    
    @IBAction final private func didTapOnSelectVideo() {
        
        if iconClose.isHidden {
            guard let delegate = delegate else { return }
            delegate.attachVideo(self)
        } else {
            lblFileName.isHidden = true
            lblUploadVideo.isHidden = false
            iconClose.isHidden = true
        }
    }
    
    @IBAction final private func btnBackAction(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.backNavigation(self)
    }
    
    @IBAction final private func didTapOnSave() {
        if isValidation() {
            setOfflineTour(TourDetails(title: textFieldTitle.text ?? "",
                                       descriptions: textViewTitle.text,
                                       filePath: filePath,
                                       latitude: latitude,
                                       longitude: longitude))
            
            alertOk(message: tourSuccess) {
                guard let delegate = self.delegate else { return }
                delegate.backNavigation(self)
            }
        }
    }
}

// MARK: - Prepare View -
private extension EditTourView {
    
    final private func alertOk(message: String,
                               completionSucess: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: { _ in
            completionSucess?()
        }))
        LIApplication.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    final private func isValidation() -> Bool {
        
        if textFieldTitle.text?.isEmpty ?? false {
            alertOk(message: tourTilteError)
            return false
        } else if lblFileName.isHidden {
            alertOk(message: tourVideoError)
            return false
        }
        return true
    }
    
    final private func setOfflineTour(_ tourDetails: TourDetails) {
        let viewModel = QueryTour(with: DBManager(persistentContainer: persistance))
        viewModel.insertList(response:tourDetails)
    }
    
    final private func setTour() {
        
        switch tourFlow {
        
        case .AddTour(let location):
            longitude = location.longitude
            latitude = location.latitude
            
        default:
            break
        }
    }
}
