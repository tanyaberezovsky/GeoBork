//
//  ToggleZoom.swift
//  GoogleMapDemo
//
//  Created by Tania on 24/12/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import Foundation


enum Direction{
    case up, down
}


/*  ToggleZoom
 *  calculate toggle zoom
 */
struct ToggleZoom {
    var maxZoom:Float
    var minZoom:Float
    var direction = Direction.up
    var currentZoom:Float = Constants.LocationData.zoom
    
    init(minZoom:Float, maxZoom:Float) {
        self.minZoom = minZoom
        self.maxZoom = maxZoom
    }
    
    mutating func resetZoom() {
        currentZoom = Constants.LocationData.zoom
        direction = Direction.up
    }
    
    mutating func toggleZoom() {
        if currentZoom == maxZoom {
            direction = Direction.down
        } else if currentZoom == minZoom {
            direction = Direction.up
        }
        
        switch direction {
        case .up:
            currentZoom += 1
        default:
            currentZoom -= 1
        }
    }
}
