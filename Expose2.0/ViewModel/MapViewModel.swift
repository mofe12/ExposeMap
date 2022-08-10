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

// All Map Data Goes here....


final class MapUIViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    let locationManagerService = LocationService.instance
    var cancellable = Set<AnyCancellable>()
    
    // File managing
    static let shared = DataProvider()
    
    private let dataSourceURL: URL
    
    @Published var allInterest = Interest(Interests: [], photos: [])
    
    //Current Page
    @Published var currentPage = changeScreen.contentView
    
    @Published var isNavActive: Bool = false
    
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
    
    // Returned Places
    @Published var noPlacesReturned: Bool = false
    
    // Searched Places...
    @Published var places : [Place] = []
    
    // places array
    @Published var placesArray: [Place] = []
    
    
    // More info view
    @Published var showMoreInfoView = false
    
    // More list view
    @Published var showInterestListView = false
    
    
    // Gotten File Manager
    @Published var FileManagerData: Interest = Interest(Interests: [], photos: [])
    // Photos to be saved
    
    @Published var selectedPhotoToShow: [UIImage] = []
    
    @Published var scannedPhotoToBeSaved: [String] = []
    
    
    // Current Interest
    @Published var currentInterest: String = "SELECT INTEREST"
    
    
    // ML results
    @Published var MLPhotoResultsToBeSaved : [String] = []
    
    @Published var NewMLPhotoResults : [String] = []
    
    @Published var MLPhotoResults: [String] = []
    
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
    
    
    func changeUIImageToString(_ uiImage: UIImage){
        //DispatchQueue.main.async {
        //for uiImage in uiImages {
        self.scannedPhotoToBeSaved.append(uiImage.toJpegString(compressionQuality: 0.0) ?? "no Image")
        
        //}
        //self.newPhotosToBeScanned = []
        //}
    }
    
    func changeStringToUIImage(_ strings: [String]){
        DispatchQueue.main.async {
            for string in strings {
                self.selectedPhotoToShow.append(string.toImage()!)
            }
        }
    }
    
    
    // Search Places and puts result in placeArray
    func searchQuery(){
        print("calling search Query")
        
        noPlacesReturned = false
        places.removeAll()
        
        placesArray.removeAll()
        
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = currentInterest
        
        // Fetch
        MKLocalSearch(request: request).start{(respose, _) in
            guard let result = respose else{return}
            
            DispatchQueue.main.async {
                self.updateMapInterestRegion(result: result)
            }
            
            self.places = result.mapItems.compactMap({(item) -> Place? in
                // -- Easy fix rn to get the places in places Array immediately
                self.placesArray.append(Place(place: item.placemark))
                return Place(place: item.placemark)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.placesArray.count == 0{
                print("does it get here")
                self.noInterestAlert()
            }
        }
    }
    
    func noInterestAlert(){
        self.noPlacesReturned = true
        alertDetail = AlertStruct(title: "No Interest Near-By", message: "I'm sorry :( there is no place related to your interest at your current location. Try choosing another interest.")
        alertValue = true
        print("No place returned: \(noPlacesReturned)")
    }
    
    // Show All Places
    func selectAllPlaces(places: [Place] ){
        // Making sure the places array is not empty
        guard places.count != 0 else{return}
        
        
        placesArray = places
        searchTxt = ""
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
    
    
    
    // Everything that has to do with file managing
    
    private func getInterest() -> Interest{
        do{
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedInterest = try! decoder.decode(Interest.self, from: data)
            return decodedInterest
        }catch{
            return Interest(Interests: [], photos: [])
        }
    }
    
    override init(){
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let interestPath = documentsPath.appendingPathComponent("interest").appendingPathExtension("json")
        dataSourceURL = interestPath
        super.init()
        subscribeToLocationPermission()
        subscribeToRegion()
        
        _allInterest = Published(wrappedValue: getInterest())
        FileManagerData = get()
        MLPhotoResults = FileManagerData.Interests
        changeStringToUIImage(FileManagerData.photos)
    }
    
    private func saveInterest(){
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allInterest)
            try data.write(to: dataSourceURL)
        } catch {
            
        }
    }
    
    func create(interest: Interest){
        allInterest.Interests.insert(contentsOf: interest.Interests, at: 0)
        allInterest.photos.insert(contentsOf: interest.photos, at: 0)
        saveInterest()
    }
    
    func get() -> Interest{
        return getInterest()
    }
    
    
}
