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
    
    // MARK: - Variable -
    var tourFlow: TourFlow = .None
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Edit Tour Delegate -
extension EditTourController: EditTourDelegate {
    
    func attachVideo(_ view: EditTourView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        imagePickerController.allowsEditing = true
        imagePickerController.modalPresentationStyle = .overFullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func backNavigation(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func saveVideo(_ view: EditTourView) {
        
    }
}

// MARK: - Picker delegate -
extension EditTourController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            
            let fileName = (videoUrl.lastPathComponent ?? "")
            picker.dismiss(animated: true, completion: nil)
            
            setVideoName(VideoFile(fileName: fileName, filePath: videoUrl.path ?? ""))
            
            plog(fileName)
            plog(videoUrl.path)
        }
    }
    
    private func setVideoName(_ video: VideoFile) {
        if let view = view as? EditTourView {
            view.videoName = video
        }
    }
}
