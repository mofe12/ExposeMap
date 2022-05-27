//
//  MapViewModel.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/16/22.
//

import SwiftUI
import MapKit
import CoreLocation

// All Map Data Goes here....


final class MapUIViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var mapView = MKMapView()
    
    // Instiating ML model
    let model = MobileNetV2()
    
    //Current Page
    @Published var currentPage = changeScreen.contentView
    
    // Setting Region
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -95), latitudinalMeters: 10000000, longitudinalMeters: 10000000)
    
    // Map type
    @Published var mapType: MKMapType = .standard
    
    // Search Text
    @Published var searchTxt = ""
    
    // Searched Places...
    @Published var places : [Place] = []
    
    // places array
    @Published var placesArray: [Place] = []
    
    // More info view
    @Published var showMoreInfoView = false
    
    // More list view
    @Published var showInterestListView = false
    
    // Photos to be scanned by the ML
    @Published var photosToBeScanned: [String] = ["lemon","strawberry", "test"]
    
    // Current Interest
    @Published var currentInterest: String = "CLICK TO SELECT INTEREST"
    
    // ML results
    @Published var MLPhotoResults : [String] = ["chess", "guitar", "car"]
    
    // More info place
    @Published var moreInfoPlace: PlaceMarked =
    PlaceMarked( name: "Academy"
                 ,addressNumber: "1001"
                 , streetName: "Grant Ave"
                 , city: "San Francisco"
                 , state: "CA"
                 , county: "test"
                 , country: "US"
                 , zipCode: "94133")
    
    
    // Updating Map type
        
    func updateMapType(){
        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
        }else{
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    // Focus Location
    
    func focusLocation(){
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    // Search Places
    func searchQuery(){
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = currentInterest
        
        // Fetch
        MKLocalSearch(request: request).start{(respose, _) in
            guard let result = respose else{return}
            
            self.places = result.mapItems.compactMap({(item) -> Place? in
                
                //Easy fix rn to get the places in places Array immediately
                self.placesArray.append(Place(place: item.placemark))
                
                return Place(place: item.placemark)
            })
        }
        setPlacesArray()
    }
    // Pick Search Results..
    
    func selectPlace(place: Place){
        // Showing pin on map...
        searchTxt = ""
        
        guard let coordinate = place.place.location?.coordinate else{return}
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "No Name"
        
        // Removing All Old Ones...
        // mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(pointAnnotation)
        
        // Moving map to the location
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        
        
        
    }
    
    
    // Show All Places
    
    func selectAllPlaces(places: [Place] ){
        // Making sure the places array is not empty
        guard places.count != 0 else{return}
        
        
        placesArray = places
        searchTxt = ""
        
        // Moving map to the location
        // updateMapRegion(place: places.first!)
        
    }
    
    func setPlacesArray(){
        placesArray = places
    }
    
    func updateMapRegion(places: [Place]){
        
        guard places.count != 0 else{return}
        
        let place = places.first!
        searchTxt = ""
        withAnimation(.easeInOut){
            self.region = MKCoordinateRegion(center: place.place.location!.coordinate,
                                             latitudinalMeters: 5000,
                                             longitudinalMeters: 5000)
        }
        print(place)
    }
    
    // Toggle Interest List view
    func toogleInterstListView(){
        withAnimation(.easeInOut) {
            showInterestListView.toggle()
        }
    }
    
    
    
    // Everything below has to do with the location of the user
    let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission(){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else{return}
        
        
        DispatchQueue.main.async{
            // does the animation with every location update
            withAnimation(.easeInOut){
                self.region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
//class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
//    @Published var mapView = MKMapView()
//
//    // Region..
//    @Published var region: MKCoordinateRegion!
//    // Based on Location It Will Set Up
//
//    // Alert...
//    @Published var permissionDenied = false
//
//    // Map type
//    @Published var mapType: MKMapType = .standard
//
//    // Search Text
//    @Published var searchTxt = ""
//
//    // Searched Places...
//    @Published var places : [Place] = []
//
//    // Updating Map type
//
//    func updateMapType(){
//        if mapType == .standard{
//            mapType = .hybrid
//            mapView.mapType = mapType
//        }else{
//            mapType = .standard
//            mapView.mapType = mapType
//        }
//    }
//
//    // Focus Location
//    func focusLocation(){
//        guard let _ = region else{return}
//
//        mapView.setRegion(region, animated: true)
//        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
//    }
//
//    // Search Places
//    func searchQuery(){
//
//        places.removeAll()
//
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchTxt
//
//        // Fetch
//        MKLocalSearch(request: request).start{(respose, _) in
//            guard let result = respose else{return}
//
//            self.places = result.mapItems.compactMap({(item) -> Place? in
//                return Place(place: item.placemark)
//            })
//        }
//    }
//
//    // Pick Search Results..
//
//    func selectPlace(place: Place){
//        // Showing pin on map...
//        searchTxt = ""
//
//        guard let coordinate = place.place.location?.coordinate else{return}
//        let pointAnnotation = MKPointAnnotation()
//        pointAnnotation.coordinate = coordinate
//        pointAnnotation.title = place.place.name ?? "No Name"
//
//        // Removing All Old Ones...
//       // mapView.removeAnnotations(mapView.annotations)
//
//        mapView.addAnnotation(pointAnnotation)
//
//        // Moving map to the location
//        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
//
//        mapView.setRegion(coordinateRegion, animated: true)
//        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
//
//
//    }
//
//
//    // Show All Places
//
//    func selectAllPlaces(places: [Place] ){
//
//        // Showing pin on map...
//        searchTxt = ""
//
//        // Removing All Old Ones...
//        mapView.removeAnnotations(mapView.annotations)
//
//        // Show all the location of the interest
//        for place in places {
//            guard let coordinate = place.place.location?.coordinate else{return}
//            let pointAnnotation = MKPointAnnotation()
//            pointAnnotation.coordinate = coordinate
//
//
//            pointAnnotation.title = place.place.name ?? "No Name"
//
//            mapView.addAnnotation(pointAnnotation)
//
//            // Moving map to the location
//            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
//
//            mapView.setRegion(coordinateRegion, animated: true)
//            mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
//
//        }
//
//    }
//
//    // Based on Location It will Set up
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        // Checking permissions...
//        switch manager.authorizationStatus{
//        case .denied:
//            // Alert
//            permissionDenied.toggle()
//        case .notDetermined:
//            // Requesting
//            manager.requestWhenInUseAuthorization()
//        case .authorizedWhenInUse:
//            // If the permission was given
//            manager.requestLocation()
//
//        default:
//            ()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Error
//        print(error.localizedDescription)
//    }
//
//    // Getting the user region
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else{return}
//
//        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
//
//        // Updating map
//        self.mapView.setRegion(self.region, animated: true)
//
//        // Smooth Animations...
//        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
//
//    }
//}
