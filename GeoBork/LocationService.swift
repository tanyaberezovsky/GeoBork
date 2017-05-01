//
//  LocationService.swift
//  GeoBork
//
//  Created by Tania on 27/03/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

//MARK: Delegate for LocationService.
protocol LocationServiceDelegate: class {
    func tracingLocation(location: CLLocation)
}

struct LocationServiceRunningState{
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    var distanceFilter:CLLocationDistance = 10
    var activityType:CLActivityType = CLActivityType.fitness
    var applicationState:UIApplicationState = UIApplicationState.active
}

class LocationService: NSObject, CLLocationManagerDelegate{

    //MARK: Properties
    weak var myDelegate: LocationServiceDelegate?
    private var manager: CLLocationManager?
    var lastLocation: CLLocation?
    var state:LocationServiceRunningState
    
    //MARK: Constractor area
    //private
    override init(){
        self.state = LocationServiceRunningState()
        super.init()
    }
    
    init(state: LocationServiceRunningState){
        self.state = state
        super.init()
        self.makeLoactionManager()
    }
    
    private func makeLoactionManager() {
        self.manager = CLLocationManager()
        guard let manager = self.manager else {
            return
        }
        
        if (CLLocationManager.locationServicesEnabled()) {
            manager.delegate = self
            manager.desiredAccuracy = state.desiredAccuracy
            manager.distanceFilter = state.distanceFilter
            manager.activityType = state.activityType
        } else {
            #if debug
                println("Location services are not enabled");
            #endif
        }
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        if let manager = manager{
            //manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
    }
    
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        if let manager = manager{
            manager.stopUpdatingLocation()
        }
    }
    
    //MARK: CLLocationManagerDelegate actoins
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopUpdatingLocation()
        print("Location services are not reachable, contact developer. Error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.last != nil else {
            return
        }
        // get last location
        self.lastLocation = locations[0]
        // use for real time update location
        updateLocation(currentLocation: locations[0])
    }
    
    private func updateLocation(currentLocation: CLLocation){
        guard let myDelegate = self.myDelegate else {
            return
        }
        
        myDelegate.tracingLocation(location: currentLocation)
    }
}

//MARK: AddressConvertions
extension LocationService {
    ///Returns an address from a location using Apple geocoder
    public func addressFromLocation(location:CLLocation!, completionClosure:@escaping ((CLPlacemark?)->())){
        DispatchQueue.global().async {
            // Background thread
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) -> Void in
                if let places = placeMarks {
                    let marks = places[0] as CLPlacemark
                    completionClosure(marks as CLPlacemark?)
                }else {
                    completionClosure(nil)
                }
            })
        }
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joined(separator: ", ")
    }
}



