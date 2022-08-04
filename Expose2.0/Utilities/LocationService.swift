//
//  MapService.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 7/29/22.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit


enum locationPermissionsEnum {
    case allow
    case notAllowed
    case restricted
    case denied
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    
    static let instance = LocationService()
    
    private override init(){}
    
    let regionAmount = { (location:  CLLocationCoordinate2D ) -> MKCoordinateRegion in
        MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
    
    // Setting Region
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -95), latitudinalMeters: 10000000, longitudinalMeters: 10000000)
    
    @Published var locationPermission: locationPermissionsEnum = .allow
    
    // All about Locations part
    var locationManager: CLLocationManager?
    
    
    
    func checkIfLocationServiceIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationPermission = .allow
        }else{
            locationPermission = .notAllowed
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            print("not determined")
            locationManager.requestWhenInUseAuthorization()
            locationPermission = .allow
        case .restricted:
            print("restricted")
            locationPermission = .notAllowed
        case .denied:
            print("denied")
            locationPermission = .notAllowed
        case .authorizedAlways, .authorizedWhenInUse:
            locationPermission = .allow
            withAnimation(.easeInOut) {
                self.region = self.regionAmount(locationManager.location!.coordinate)
            }
        @unknown default:
            break
        }
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func updateMapRegion(){
        guard let locationManager = locationManager else { return }
        
        print("LOCATION PERMISSION: \(locationPermission)")
        
        withAnimation(.easeInOut) {
            if let location = locationManager.location {
                self.region = regionAmount(location.coordinate)
            }
        }
    }
    
}
