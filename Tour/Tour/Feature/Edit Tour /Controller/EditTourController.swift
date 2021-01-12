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
    case ViewTour(_ tourAnnotation: TourAnnotation)
    case AddTour(_ coordinate: CLLocationCoordinate2D)
    case None
}

private struct EditTourSuccessKeys {
    static let tourCamera = "You can't access camera right now"
    static let tourGallery = "You can't access gallery right now"
    static let alertTitle = "Alert"
    static let ok = "Ok"
    static let selectVideo = "Select Video"
    static let selectVideoMessage = "Please select below option to record or attach video from gallery"
    static let recordVideo = "Record Video"
    static let gallery = "Attach From Gallery"
}

class EditTourController: UIViewController {
    
    // MARK: - Variable -
    var tourFlow: TourFlow = .None
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
}

// MARK: - Prepare View  -
private extension EditTourController {
    
    final private func setVideoName(_ video: VideoFile) {
        if let view = view as? EditTourView {
            view.videoName = video
        }
    }
    
    final private func prepareView() {
        if let view = view as? EditTourView {
            view.tourFlow = tourFlow
        }
    }
}

// MARK: - Edit Tour Delegate -
extension EditTourController: EditTourDelegate {
    
    func attachVideo() {
        let alert = UIAlertController(title: EditTourSuccessKeys.selectVideo,
                                      message: EditTourSuccessKeys.selectVideoMessage,
                                      preferredStyle: .alert)
        
        let camera = UIAlertAction(title: EditTourSuccessKeys.recordVideo,
                                   style: .default, handler: { action in
                                    self.openVideoPicker(.camera)
                                   })
        alert.addAction(camera)
        let gallery = UIAlertAction(title: EditTourSuccessKeys.gallery,
                                    style: .default, handler: { action in
                                        self.openVideoPicker(.photoLibrary)
                                    })
        alert.addAction(gallery)
        present(alert, animated: true)
    }
    
    func backNavigation() {
        navigationController?.popViewController(animated: true)
    }
    
    final private func openVideoPicker(_ sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = [kUTTypeMovie as String]
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = .overFullScreen
            present(imagePickerController, animated: true, completion: nil)
        } else {
            showAlertForPicker(sourceType)
        }       
    }
    
    final private func showAlertForPicker(_ sourceType: UIImagePickerController.SourceType) {
        if sourceType == .camera {
            alertWithOk(EditTourSuccessKeys.tourCamera) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            alertWithOk(EditTourSuccessKeys.tourGallery) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    final private func alertWithOk(_ message: String,
                                   completionSucess: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: EditTourSuccessKeys.alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: EditTourSuccessKeys.ok, style: .default, handler: { _ in
            completionSucess?()
        }))
        LIApplication.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
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
}
