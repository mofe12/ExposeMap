//
//  MapViewModel.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/16/22.
//

import SwiftUI
import MapKit
import UIKit
import PhotosUI
import CoreLocation
import Combine
import CoreData

// All Map Data Goes here....


final class MapUIViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    let locationManagerService = LocationService.instance
    
    let coreDataManager = CoreDataService.instance
    
    var cancellable = Set<AnyCancellable>()
    
    
    
    //Current Page
    @Published var photoViewIsPresented = false
    
    @Published var isNavActive: Bool = false
    
    @Published var showPhotoScreen: Bool = false
    
    // Setting Region
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -95), latitudinalMeters: 10000000, longitudinalMeters: 10000000)
    
    
    
    // MapView permissions

    @Published var alertValue: Bool = false
    
    
    @Published var alertDetail =
    AlertStruct(title: "" , message: "")
    
    @Published var locationPermission: locationPermissionsEnum = .notAllowed {
        didSet{
            switch locationPermission{
                
            case .allow:
                alertValue = false
            case .notAllowed:
                alertDetail = AlertStruct(title: "Location Disabled", message: "Your location is off, turn on to use app")
                alertValue = true
            case .restricted:
                alertDetail = AlertStruct(title: "Restricted Location", message: "Your current location can’t be determined because it is restricted. For great experience, Allow Exposé to use your location.\n Select \"While Using the App.\"")
                alertValue = true
            case .denied:
                alertDetail = AlertStruct(title: "Denied Location", message: "You have DENIED the app location, go to settings to change it. For great experience, allow Exposé to use your location.\n Select \"While Using the App.\"")
                alertValue = true

            }
        }
    }

    // Search Text
    @Published var searchTxt = ""
    
    
    // Searched Places...
    @Published var places : [Place] = []
    
    
    // More info view
    @Published var showMoreInfoView = false
    
    // More list view
    @Published var showInterestListView = false
    
    
    // Gotten File Manager
    
    @Published var gottenInterest: [AppInterest] = []
    
    
    
    
    
    @Published var FileManagerData: AppInterest = AppInterest(interest: nil, photos: nil)
    // Photos to be saved
    
    @Published var selectedPhotoToShow: [AppInterest] = []
    
    
    // Current Interest
    @Published var currentInterest: String = "SELECT INTEREST"
    
    
    // ML results
    @Published var MLPhotoResultsToBeSaved : [String] = []
    
    @Published var MLPhotoResults: [AppInterest] = [AppInterest(interest: nil, photos: nil)]
    

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
    
        

    @Published var interestEntities: [InterestEntity] = []
    
    func getInterest(){
        let request = NSFetchRequest<InterestEntity>(entityName: "InterestEntity")
        
        do{
            interestEntities = try coreDataManager.context.fetch(request)
        }catch let error{
            print("ERROR FETCHING ENTRY. \(error.localizedDescription)")
        }
    }
    
    // Search Places and puts result in placeArray
    func searchQuery(){
        print("calling search Query")

        places.removeAll()
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = currentInterest
        
        // Fetch
        MKLocalSearch(request: request).start{(respose, _) in
            guard let result = respose else{return}
            
            DispatchQueue.main.async {
                
                self.places = result.mapItems.compactMap({(item) -> Place? in
                    // -- Easy fix rn to get the places in places Array immediately
                    return Place(place: item.placemark)
                })
                self.updateMapInterestRegion(result: result)
                if self.places.isEmpty{
                    print("Its empty")
                    self.noInterestAlert()
                }
            }
            
            
        }
    }
    
    func noInterestAlert(){
        alertDetail = AlertStruct(title: "No Interest Near-By", message: "I'm sorry :( there is no place related to your interest at your current location. Try choosing another interest.")
        alertValue = true
    }
    
    
    // Updates the map to the region of the new interest selected
    func updateMapInterestRegion(result:  MKLocalSearch.Response){
        withAnimation(.easeInOut) {
            self.region = result.boundingRegion
        }
    }
    
    
    
    // Toggle Interest List view
    func toogleInterstListView(){
        withAnimation(.easeInOut) {
            showInterestListView.toggle()
        }
    }
    
    
    
    
    // All about Locations part
    
    
    func subscribeToLocationPermission(){
        locationManagerService.$locationPermission
            .sink { (completion) in
                switch completion{
                    
                case .finished:
                    print("It finished")
                }
                print("COMPLETION \(completion)")
            } receiveValue: { (permissions) in
                self.locationPermission = permissions
            }
            .store(in: &cancellable)
        
    }
    
    func subscribeToRegion(){
        locationManagerService.$region
            .sink { [weak self] region in
                self?.region = region
            }
            .store(in: &cancellable)
    }
    

    override init(){
        super.init()
        subscribeToLocationPermission()
        subscribeToRegion()
    }
    

    
}
