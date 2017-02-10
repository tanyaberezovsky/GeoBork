//
//  Azimuth.swift
//  GoogleMapDemo
//
//  Created by Tania on 01/01/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Foundation
import CoreLocation

struct Azimuth {
    var currentAzimuthAngle:Double?
    
    init() {}
    
    mutating func validateAzimuthAngle(headingDegree:CLLocationDirection) -> Bool{
        let angle:Double = headingDegree * M_PI / 180
        if let currentAzimuthAngle = self.currentAzimuthAngle{
            if abs(currentAzimuthAngle - angle) <= 0.1 {
                return false //UI already updated
            } else {
                setAzimuthAngle(angle)
                return true // receive diferent location -> Update UI
            }
            
        } else { //first time -> update UI
            setAzimuthAngle(angle)
            return true
        }
    }
    
    mutating func setAzimuthAngle(_ angle:Double){
        currentAzimuthAngle = angle
    }
    
   
}
