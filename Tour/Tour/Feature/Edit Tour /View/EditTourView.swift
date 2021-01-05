//
//  EditTourView.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import MapKit
import AVKit

struct VideoFile {
    var fileName = ""
    var filePath = ""
}

// MARK: - View Delegate -
@objc protocol EditTourDelegate {
    func attachVideo()
    func backNavigation()
}

private struct EditTourAlertKeys {
    static let tourTilteError = "Please enter tour title"
    static let tourVideoError = "Please select tour video"
    static let tourSuccess = "Tour created successfully"
    static let alertTitle = "Alert"
    static let ok = "Ok"
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

    final private var filePath = ""
    final private var latitude: Double = 0
    final private var longitude: Double = 0
    
    final private var player = AVPlayer()
    final private var playerLayer = AVPlayerLayer()
    
    final private var playVideo = false
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
        if playVideo {
            let videoUrl = URL(fileURLWithPath: filePath)
            playVideo(videoUrl)
        } else if iconClose.isHidden {
            guard let delegate = delegate else { return }
            delegate.attachVideo()
        } else {
            lblFileName.isHidden = true
            lblUploadVideo.isHidden = false
            iconClose.isHidden = true
        }
    }
    
    @IBAction final private func btnBackAction() {
        guard let delegate = delegate else { return }
        delegate.backNavigation()
    }
    
    @IBAction final private func didTapOnSave() {
        if isValidData() {
            setOfflineTour(TourDetails(title: textFieldTitle.text ?? "",
                                       descriptions: textViewTitle.text,
                                       filePath: filePath,
                                       latitude: latitude,
                                       longitude: longitude))
            
            alertWithOk(EditTourAlertKeys.tourSuccess) {
                guard let delegate = self.delegate else { return }
                delegate.backNavigation()
            }
        }
    }
    
    private func playVideo(_ playableURL: URL?) {
        if let videoURL = playableURL {
            player = AVPlayer(url: videoURL)
        }
        player.volume = 10
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        superview?.parentViewController?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

// MARK: - Prepare View -
private extension EditTourView {
    
    final private func alertWithOk(_ message: String,
                               completionSucess: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: EditTourAlertKeys.alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: EditTourAlertKeys.ok, style: .default, handler: { _ in
            completionSucess?()
        }))
        LIApplication.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    final private func isValidData() -> Bool {
        
        if textFieldTitle.text?.isEmpty ?? false {
            alertWithOk(EditTourAlertKeys.tourTilteError)
            return false
        } else if lblFileName.isHidden {
            alertWithOk(EditTourAlertKeys.tourVideoError)
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
            
        case .ViewTour(let annotation):
            playVideo = true
            lblUploadVideo.text = "Play Video"
            addVideoButton.isHidden = true
            filePath = annotation.filePath ?? ""

            textFieldTitle.text = annotation.title?.capitalized
            textFieldTitle.isUserInteractionEnabled = false
            
            textViewTitle.isUserInteractionEnabled = false
            textViewTitle.text = annotation.subtitle?.capitalized
        default:
            break
        }
    }
}
