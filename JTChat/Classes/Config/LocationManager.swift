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
        if let lat = UserInfo.shared.lat, lat > 0, let lon = UserInfo.shared.lon, lon > 0 {
            if let location = locations.first {
                UserInfo.shared.currentLon = location.coordinate.longitude
                UserInfo.shared.currentLat = location.coordinate.latitude
                if let gpslimi = UserInfo.shared.emp_gpsLimitDistance, gpslimi > 0, let gpsenable = UserInfo.shared.emp_isAppLocation, gpsenable == true {
                    if location.distance(from: CLLocation(latitude: lat, longitude: lon)) < Double(gpslimi) {
                        UserInfo.shared.enableWorkbench = true
                    } else {
                        UserInfo.shared.enableWorkbench = false
                    }
                } else {
                    UserInfo.shared.enableWorkbench = true
                }
                
                if let limi = UserInfo.shared.limitDistance, limi > 0 {
                    if location.distance(from: CLLocation(latitude: lat, longitude: lon)) < limi {
                        UserInfo.shared.enableGPSSignup = true
                    } else {
                        UserInfo.shared.enableGPSSignup = false
                    }
                } else {
                    UserInfo.shared.enableGPSSignup = true
                }
            } else {
                UserInfo.shared.enableWorkbench = true
                UserInfo.shared.enableGPSSignup = false
            }
        } else {
            UserInfo.shared.enableGPSSignup = false
            UserInfo.shared.enableWorkbench = true
        }
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
