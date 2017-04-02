//
//  LocationSelectorViewController.swift
//  GeoBork
//
//  Created by Tania on 27/03/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit
import GoogleMaps


class LocationSelectorViewController: UIViewController {
    //MARK:properties
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var markerImage: UIImageView!
    
    var newLocation:CLLocation!
    
    
    var _locationService: LocationService?/*{
        
        return LocationService.sharedInstance
        
    }*/
    var locationService: LocationService{
        if _locationService == nil{
            _locationService = LocationService()
        }
        return _locationService!
    }
    // bMARK: UIViewController FunctionssharedInstance
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setAppearance()
        
        defineGoogleMap()
        
        setLocationService()
        
        self.locationService.startUpdatingLocation()
    }
    
    
    
    //MARK: Help General Functions
    private func setAppearance(){
    
        translateScreenCaptions()
        
    }
    
    
    
    private func defineGoogleMap(){
 
        self.mapView.delegate = self
        
    }
    
    private func setLocationService(){
        
       // LocationService.sharedInstance//start location manager
        
        //LocationService.sharedInstance.myDelegate = self
        locationService.myDelegate = self
        
    }
    
    //MARK: Help UI Functions
    
    private func roundUIElementConers(){
        
        btnContinue.layer.cornerRadius = 6
        
    }
 
    private func translateScreenCaptions(){
        
        btnContinue.setTitle(NSLocalizedString("CONTINUEWITHCURRENLOCATION", comment: ""), for: .normal)
        
    }
    
}



extension LocationSelectorViewController: LocationServiceDelegate{
    
    //MARK: LocationServiceDelegate
    
    func tracingLocation(location: CLLocation){
        
        self.locationService.stopUpdatingLocation()
        
        setMapCamera(location: location)
        
    }
    
    
    
}

//MARK:GMSMapViewDelegate functions

extension LocationSelectorViewController: GMSMapViewDelegate{
 
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        newLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        
    }
    
    func setMapCamera(location: CLLocation){
        mapView.camera =  GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: Constants.LocationData.zoom)
        
    }
}



