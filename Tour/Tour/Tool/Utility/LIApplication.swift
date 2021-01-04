//
//  LIApplication.swift
//  Tour
//
//  Narendra Pandey on 04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import UIKit

class LIApplication {
    
    static let shared = LIApplication()
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init() { }
    
    // MARK: - Prepare View -
    func prepareView() {
        
    }
}

// MARK: - Application Bundle -
extension Bundle {
    var appName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    var appShortVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    var appBuildVersion: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    var appVersion: String {
        return "\(appShortVersion) (\(appBuildVersion))"
    }
}
