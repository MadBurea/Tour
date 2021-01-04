//
//  LocationManager.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import UIKit
import CoreLocation

fileprivate struct LocationManagerSetting {
    static let NO_OF_MINUTE: Double = 1.0
    static let NO_OF_SECS_IN_MIN: Double = 10.0
}

class TSLocationManger: CLLocationManager {
    
    // MARK: - Variable -
    static let TS_LOCATION_MANAGER_UPDATE_LOCATION_NOTIFICATION = "TS_LOCATION_MANAGER_UPDATE_LOCATION_NOTIFICATION"
    static let LOCATION_TRACKING = "LOCATION_TRACKING"

    static private var _locationManager  =  TSLocationManger()
    var cordinate: CLLocationCoordinate2D?
    
    // MARK: - Instance Object -
    class final func locationManager() -> TSLocationManger {
        _locationManager = TSLocationManger()
        if _locationManager.responds(to: #selector(requestAlwaysAuthorization)) {
            _locationManager.requestAlwaysAuthorization()
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.distanceFilter = 0
        _locationManager.delegate = _locationManager
        _locationManager.headingFilter = 5
        
        _locationManager.pausesLocationUpdatesAutomatically = false
        return _locationManager
    }
    
    /// This method will monitor user location
    final func monitorLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .denied {
            plog("Location services are disabled in settings")
        } else {
            
            if TSLocationManger._locationManager.responds(to: #selector(requestAlwaysAuthorization)) {
                TSLocationManger._locationManager.requestAlwaysAuthorization()
            }
            
            if TSLocationManger._locationManager.responds(to: #selector(getter: allowsBackgroundLocationUpdates)) {
                TSLocationManger._locationManager.allowsBackgroundLocationUpdates = true
            }
            TSLocationManger._locationManager.startUpdatingLocation()
            
            
            Timer.scheduledTimer(withTimeInterval: LocationManagerSetting.NO_OF_MINUTE * LocationManagerSetting.NO_OF_SECS_IN_MIN,
                                 repeats: true) { (timer) in
                if status != .denied,
                   let location: CLLocation = TSLocationManger._locationManager.location {
                    plog(location)
                    self.setOfflineTourLocation(TourLocationDetail(latitude: location.coordinate.latitude,
                                                                   longitude: location.coordinate.longitude, time: Date()))
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: TSLocationManger.LOCATION_TRACKING),
                                                    object: self)
                }
            }
        }
    }
    
    final private func setOfflineTourLocation(_ location: TourLocationDetail) {
        let viewModel = QueryTourLocation(with: DBManager(persistentContainer: persistance))
        viewModel.insertList(response:location)
    }
}

// MARK: - CLLocation Manager Delegate -
extension TSLocationManger : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        cordinate = locations.last?.coordinate
        NotificationCenter.default.post(name: Notification.Name(rawValue: TSLocationManger.TS_LOCATION_MANAGER_UPDATE_LOCATION_NOTIFICATION),
                                        object: self)
    }
}
