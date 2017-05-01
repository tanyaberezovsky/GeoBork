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
    
    @IBOutlet weak var address: UILabel!
    
    var delegateMap: MapListener?
    
    var newLocation:CLLocation!
    var _locationService: LocationService?
    
    
    var locationService: LocationService{
        if _locationService == nil{
            _locationService = LocationService(state: LocationServiceRunningState())
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
        locationService.myDelegate = self
    }
    
    //MARK: Help UI Functions
    
    private func roundUIConers(){
        btnContinue.layer.cornerRadius = 6
    }
 
    private func translateScreenCaptions(){
        btnContinue.setTitle(NSLocalizedString("CONTINUEWITHCURRENLOCATION", comment: ""), for: .normal)
    }
    
    @IBAction func addMarker(_ sender: Any) {
        requestCreateBork(location: newLocation)
        delegateMap?.reloadMap()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        //self.parent!.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:Actions
extension LocationSelectorViewController{
    
}

extension LocationSelectorViewController: LocationServiceDelegate{
    
    //MARK: LocationServiceDelegate
    
    func tracingLocation(location: CLLocation){
        
        self.locationService.stopUpdatingLocation()
        
        setMapCamera(location: location)
        
    }
    
}

//MARK:GMSMapViewDelegate

extension LocationSelectorViewController: GMSMapViewDelegate{
 
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        newLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        self.locationService.addressFromLocation(location: newLocation, completionClosure: {  places in
            if let places = places{
                self.address.text = self.locationService.formatAddressFromPlacemark(placemark: places)
            }
        })
    }
    
    func setMapCamera(location: CLLocation){
        mapView.camera =  GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: Constants.LocationData.zoom)
        
    }
}

//MARK:Networking
extension LocationSelectorViewController{
    func requestCreateBork(location: CLLocation){
        var parameters = Parametrs()
        parameters["lat"] = location.coordinate.latitude
        parameters["lng"] = location.coordinate.longitude
        print(parameters["lat"]!)
        print(parameters["lng"]!)
        parameters["name"] = ""
        parameters["type"] = "inspector"
        ApiManager.sharedInstance.createBork(parameters: parameters)  {
            result in
                print(result)
        }
        
    }
}

