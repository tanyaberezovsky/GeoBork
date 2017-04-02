//
//  MapViewController.swift
//  GeoBork
//
//  Created by Tania on 17/01/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit
import GoogleMaps


protocol LayoutConstraintProtocol{

}

protocol UIDefinitionProtocol{
    func LoadMapsComponents()
    func LoadGeneralComponents()
}


protocol MapActionsProtocol {
    func addMarker(location: CLLocation)
    func setMapCamera(location: CLLocation)
}
/*
 *  MapViewController
 *
 *  controls google map actions and functionality
 */

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
    //MARK:properties
    @IBOutlet weak var mapView: GMSMapView!
    
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
    
    
    //MARK: UIViewController FunctionssharedInstance
    
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
    
    private func translateScreenCaptions(){
        //btnContinue.setTitle(NSLocalizedString("CONTINUEWITHCURRENLOCATION", comment: ""), for: .normal)
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
        
    //    btnContinue.layer.cornerRadius = 6
        
    }
    
  
    
}



extension MapViewController: LocationServiceDelegate{
    
    //MARK: LocationServiceDelegate
    
    func tracingLocation(location: CLLocation){
        
      self.locationService.stopUpdatingLocation()
      print("tracingLocation")
        setMapCamera(location: location)
        
    }
    
    
    
}

//MARK:GMSMapViewDelegate functions

extension MapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        newLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        
    }
    
    func setMapCamera(location: CLLocation){
        mapView.camera =  GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: Constants.LocationData.zoom)
        
    }
}




extension MapViewController: UIDefinitionProtocol {
    internal func LoadGeneralComponents() {
        
    }

    
    func LoadMapsComponents(){
        let camera = GMSCameraPosition.camera(withLatitude: 0,
                                              longitude: 0,
                                              zoom: 14)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        
     
        
    }
 
}


/*
//MARK: Actions on map
extension MapViewController: MapActionsProtocol{
    
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

*/
