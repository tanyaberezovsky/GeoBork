//
//  Location.swift
//  GoogleMapDemo
//
//  Created by Tania on 01/01/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    var currentLocation: CLLocation?
    
    init() {}
    
   
    mutating func validateLocation(location: CLLocation) -> Bool{
        if let currentLocation = self.currentLocation{
            if location.coordinate.latitude == currentLocation.coordinate.latitude && location.coordinate.longitude == currentLocation.coordinate.longitude{
                return false //UI already updated
            } else {
                setCurrentLocation(location)
                return true // receive diferent location -> Update UI
            }
            
        } else { //first time -> update UI
            setCurrentLocation(location)
            return true
        }
    }
    
    mutating func setCurrentLocation(_ location: CLLocation){
        self.currentLocation = location
    }
}
