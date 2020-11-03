//
//  LocationManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/13.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
class LocationManager: NSObject {
    static let manager = LocationManager()
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = .pi
        locationManager.distanceFilter = 30.0
        locationManager.pausesLocationUpdatesAutomatically = false;
    }
    
    func startLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
//            SVPShowError(content: "需要您打开定位功能，以用户定位考勤")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func endLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            SVProgressHUD.showInfo(withStatus: "需要您打开定位功能，以用户定位考勤")
            endLocation()
        } else {
            startLocation()
        }
    }
}
