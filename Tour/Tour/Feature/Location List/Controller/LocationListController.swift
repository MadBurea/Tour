//
//  LocationListController.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import CoreData

class LocationListController: UIViewController {
    
    // MARK: - Variable -
    final private let alertTitle = "Alert"
    final private let ok = "Ok"
    final private let locationTracking = "No Location tracking found yet"
    final private let fileName = "locationTracking.csv"
    final private let newLocationUpdate = "New Tracking Location Found"
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
}

// MARK: - List Delegate -
extension LocationListController: LocationListDelegate {
    
    func backNavigation(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func exportLocation(_ view: LocationListView) {
        let list = getTourLocation()
        if list.isEmpty {
            alertOk(message: locationTracking)
        } else {
            exportDatabase()
        }
    }
}

// MARK: - Prepare View -
private extension LocationListController {
    
    final private func prepareView() {
        refreshLocation()
        updateNewLocation()
    }
    
    final private func getTourLocation() -> [TourLocationDetail] {
        let viewModel = QueryTourLocation(with: DBManager(persistentContainer: persistance))
        return viewModel.getList(where: nil)
    }
    
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
    
    @IBAction final private func refreshLocation() {
        if let view = view as? LocationListView {
            view.locationDetails = getTourLocation()
        }
    }
    
    @IBAction final private func showNewLocation() {
        refreshLocation()
        if Thread.isMainThread {
            showToast(message: newLocationUpdate, seconds: 5.0)
        }
    }
    
    final private func updateNewLocation() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: TSLocationManger.LOCATION_TRACKING),
                                                  object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showNewLocation),
            name: NSNotification.Name(rawValue: TSLocationManger.LOCATION_TRACKING),
            object: nil)
    }
}

// MARK: - Export Database -
private extension LocationListController {
    
    final private func getTourManagedObject() -> [NSManagedObject] {
        let viewModel = QueryTourLocation(with: DBManager(persistentContainer: persistance))
        return viewModel.getAllManagedObject()
    }
    
    final private func exportDatabase() {
        let exportString = createExportString()
        saveAndExport(exportString: exportString)
    }
    
    final private func saveAndExport(exportString: String) {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let exportFilePath = documentsDirectoryURL.appendingPathComponent(fileName)
        plog(exportFilePath)
        
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath.path)
        FileManager.default.createFile(atPath: exportFilePath.path,
                                       contents: NSData() as Data,
                                       attributes: nil)
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            plog("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath.path)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.mail
            ]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    final private func createExportString() -> String {
        
        var latitude: Double?
        var Longitude: Double?
        var time: Date?
        
        var export: String = NSLocalizedString("Latitude, Longitude, Time \n", comment: "")
        
        getTourManagedObject().forEach { (itemList) in
            latitude = itemList.value(forKey: "latitude") as! Double?
            Longitude = itemList.value(forKey: "longitude") as! Double?
            time = itemList.value(forKey: "time") as! Date?
            
            export += "\(latitude!),\(Longitude!),\(time!) \n"
        }
        plog(export)
        return export
    }
}
