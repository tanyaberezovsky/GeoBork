//
//  LocationManager.swift
//  GoogleMapDemo
//
//  Created by Tania on 22/12/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation


/*
 *  LocationManagerDelegate
 *  Delegate for LocationManager.
 */
protocol LocationManagerDelegate: class {
  func UpdateLocations(location: CLLocation)
}

/*
 *  DeviceDirectionDelegate
 *  Delegate for LocationManager.
 */
protocol DeviceDirectionDelegate: class {
    func UpdateAzimuth(angle: Double)
}
/*
 *  LocationManager
 *
 *  Singleton. Entry point to the location service.
 */
class LocationManager: NSObject, CLLocationManagerDelegate{

    //MARK: Properties
    static let shared = LocationManager()
    weak var myDelegate: LocationManagerDelegate?
    weak var compassDelegate: DeviceDirectionDelegate?
    private var manager = CLLocationManager()
    var location = Location()
    var azimuth = Azimuth()
    
    //MARK: Constractor area
    private override init(){
        super.init()
        makeLoactionManager()
    }
  
  private func makeLoactionManager() {
     if (CLLocationManager.locationServicesEnabled()) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if ((UIDevice.current.systemVersion as NSString).floatValue >= 8){
            manager.requestWhenInUseAuthorization()//for use in foreground
        }
        // Set a movement threshold for new events.
       // manager.distanceFilter = CLLocationDistance(Constants.LocationData.distanceFilter); // meters
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
     } else {
        #if debug
            println("Location services are not enabled");
        #endif
     }
  }
  
    //MARK: CLLocationManagerDelegate actoins
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("Location services are not reachable, contact developer. Error: \(error.localizedDescription)")
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //***show azimuth change, only when app in use, in case to save user buttary***
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            let headingDegree:CLLocationDirection = (newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading)
            if let compassDelegate = self.compassDelegate{
                if azimuth.validateAzimuthAngle(headingDegree: headingDegree){
                    compassDelegate.UpdateAzimuth(angle: azimuth.currentAzimuthAngle!)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //***show location on map, only when app in use, in case to save user buttary***
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
                //update map
                if let myDelegate = self.myDelegate {
                    if location.validateLocation(location: locations[0]) {                        
                        myDelegate.UpdateLocations(location: location.currentLocation!)
                    }
                }            
        }
    }
    
    

}
