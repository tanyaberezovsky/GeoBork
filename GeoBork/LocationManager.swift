//
//  LocationManager.swift
//  GeoBork
//
//  Created by Tania on 31/03/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Foundation
import CoreLocation

class LocatioManager{

    static let sharedInstance = LocatioManager()
    
    var _locationService: LocationService?
    
    var locationService: LocationService{
        if _locationService == nil{
            _locationService = LocationService()
        }
        return _locationService!
    }
    
    init() {
        locationService.myDelegate = self
    }
    
    func startUpdatingLocation() {
        self.locationService.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationService.stopUpdatingLocation()
    }
}

//MARK: LocationServiceDelegate
extension LocatioManager: LocationServiceDelegate{
    
    func tracingLocation(location: CLLocation){
        self.stopUpdatingLocation()
    }
}
