//
//  EditTourController.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import MobileCoreServices
import MapKit
import AVFoundation
import AVKit

enum TourFlow {
    case AddTour(_ coordinate: CLLocationCoordinate2D)
    case None
}


class EditTourController: UIViewController {
    
    @IBOutlet final weak private var textFieldTitle: UITextField!
    @IBOutlet final weak private var textViewTitle : UITextView!
    
    @IBOutlet final weak private var addVideoButton : UIButton!
    
    var tourFlow : TourFlow = .None
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


extension EditTourController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction final private func didTapOnSelectVideo() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as? NSURL
        print(videoURL)
        picker.dismiss(animated: true, completion: nil)
        
//        if let videoURL = videoURL{
//          let player = AVPlayer(URL: videoURL)
//
//          let playerViewController = AVPlayerViewController()
//          playerViewController.player = player
//
//          presentViewController(playerViewController, animated: true) {
//            playerViewController.player!.play()
//          }
//        }
    }
}
