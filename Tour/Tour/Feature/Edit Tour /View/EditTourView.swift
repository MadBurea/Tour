//
//  EditTourView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit

struct VideoFile {
    var fileName = ""
    var filePath = ""
}

// MARK: - View Delegate -
@objc protocol EditTourDelegate {
    func attachVideo(_ view: EditTourView)
    func saveVideo(_ view: EditTourView)
    func backNavigation(_ sender: UIButton)
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
    private let tourTilteError = "Please enter tour title"
    private let tourVideoError = "Please upload tour video"
    private let alertTitle = "Alert"
    private let ok = "Ok"
    private var filePath = ""
    
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
        delegate.backNavigation(sender)
    }
    
    @IBAction final private func didTapOnSave() {
        if isValidation() {
            guard let delegate = delegate else { return }
            delegate.saveVideo(self)
        }
    }
}

// MARK: - Prepare View -
private extension EditTourView {
    
    private func alertOk(message: String) {
        
        let alert = UIAlertController(title: alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
        LIApplication.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func isValidation() -> Bool {
        
        if textFieldTitle.text?.isEmpty ?? false {
            alertOk(message: tourTilteError)
            return false
        } else if lblFileName.isHidden {
            alertOk(message: tourVideoError)
            return false
        }
        return true
    }
}
