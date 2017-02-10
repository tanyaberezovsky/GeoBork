//
//  MapViewController.swift
//  GeoBork
//
//  Created by Tania on 17/01/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit

import GoogleMaps

/*
 *  MapViewController
 *
 *  controls google map actions and functionality
 */
class MapViewController: UIViewController {
    
    var mapView: GMSMapView?
    var marker = GMSMarker()
    
    
    //define mapView layout
    var constraints:  [NSLayoutConstraint]  {
        if let mapView = self.mapView {
            return [
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                mapView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ]
        } else {
            return [NSLayoutConstraint]()
        }
    }
    
    //MARK:Controler functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 0,
                                              longitude: 0,
                                              zoom: 14)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        
        if let mapView = self.mapView {
            mapView.translatesAutoresizingMaskIntoConstraints = false
            mapView.isMyLocationEnabled = false
            mapView.settings.zoomGestures = false
            self.view.insertSubview(mapView, at: 0)
        }
        NSLayoutConstraint.activate(constraints)//set auto layout for google mapView
      
        _ = LocationManager.shared//start location manager
        LocationManager.shared.myDelegate = self

    }
    
}

//MARK: Actions on map
extension MapViewController{
    
    //Creates a marker in the center of the map.
    func addMarker(location: CLLocation){
        marker.map = nil//remove previews marker
        marker.position = CLLocationCoordinate2D(latitude:  location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.icon = UIImage(named:"pointer32.jpg")
        marker.map = mapView
    }
    
    func setMapCamera(location: CLLocation){
        if  let mapView = mapView {//let toggleZoom = toggleZoom,
            mapView.camera =  GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)//toggleZoom.currentZoom)
        }
    }

}


extension MapViewController: LocationManagerDelegate{
    //MARK: LocationManagerDelegate
    func UpdateLocations(location: CLLocation){
        setMapCamera(location: location)
        addMarker(location: location)
    }
    
}
