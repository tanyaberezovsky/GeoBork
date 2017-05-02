//
//  MapViewController.swift
//  GeoBork
//
//  Created by Tania on 17/01/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit
import GoogleMaps


protocol MapListener {
    func reloadMap()
}
protocol UIDefinitionProtocol{
    func LoadMapsComponents()
    func LoadGeneralComponents()
}

protocol MapActionsProtocol {
    func addMarker(bork: Bork)
  //  func setMapCamera(location: CLLocation)
}

class MapViewController: UIViewController {
    //MARK:properties
    @IBOutlet weak var mapView: GMSMapView!
    var newLocation:CLLocation!
    var _locationService: LocationService?
    
    
    var locationService: LocationService{
        if _locationService == nil{
            _locationService = LocationService(state: LocationServiceRunningState())
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
        locationService.myDelegate = self
    }
    
    @IBAction func unwindToMap(segue:UIStoryboardSegue){
        self.locationService.startUpdatingLocation()
    }
}

extension MapViewController: LocationServiceDelegate{
    func tracingLocation(location: CLLocation){
        self.locationService.stopUpdatingLocation()
        print("tracingLocation")
        //let locHome: CLLocation = CLLocation(latitude: 32.093759, longitude: 34.787946)

        setMapCamera(location: location)
        requestBorkMarkers(location: location)
    }
}

//MARK:Networking
extension MapViewController{
    func requestBorkMarkers(location: CLLocation){
        var parameters = Parametrs()
        parameters["lat"] = location.coordinate.latitude
        parameters["lng"] = location.coordinate.longitude
        parameters["radius"] = 2000
        parameters["ago"] = 900000
        ApiManager.sharedInstance.loadBorks(parameters: parameters) {
            (borks:[Bork]) in
            print(borks.count)
            self.addMarkers(borks: borks)
        }
    }
}
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



//MARK: Actions on map
extension MapViewController: MapActionsProtocol{
    func addMarkers(borks:[Bork]){
        DispatchQueue.main.async {
            borks.forEach({self.addMarker(bork: $0)})        }
    }
    //Creates a marker in the center of the map.
    func addMarker(bork:Bork){
        let marker = GMSMarker()
        marker.map = nil//remove previews marker
        marker.position = CLLocationCoordinate2D(latitude:  bork.loc.latitude, longitude: bork.loc.longitude)
        marker.icon = UIImage(named: bork.type)
        marker.map = mapView
    }
    func addMarker(loc: CLLocation){
        let marker = GMSMarker()
        marker.map = nil//remove previews marker
        marker.position = CLLocationCoordinate2D(latitude:  loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        marker.icon = UIImage(named: "inspector")
        marker.map = mapView
    }
    
 /*   func setMapCamera(location: CLLocation){
        if  let mapView = mapView {//let toggleZoom = toggleZoom,
            mapView.camera =  GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)//toggleZoom.currentZoom)
        }
    }*/

}

extension MapViewController: MapListener {
    func reloadMap(){
        self.locationService.startUpdatingLocation()
    }
}

