//
//  AppDelegate.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variable
    var window: UIWindow?
    final private var locationManager = CLLocationManager()
    
    // MARK: - Application Life cycle -
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        plog(paths[0])
        
        #endif
       // checkLocationAuthorizationStatus()
        return true
    }
    
    final private func checkLocationAuthorizationStatus() {
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Location manager delegate -
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        plog("New Location")
        plog(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        plog("Fail to \(error)")
    }
}
