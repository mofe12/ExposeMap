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

// All Map Data Goes here....


final class MapUIViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
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
    
    // Showing image picker
    @Published var isShowingImagePicker = false
    
    @Published var photosToBeScanned: [UIImage] = []
    
    // Current Interest
    @Published var currentInterest: String = "SELECT INTEREST"

    
    // ML results
    @Published var MLPhotoResults : [String] = []
    
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
    
    
    // Handle result
    func handleResults(_ results: [PHPickerResult]) {
      for result in results {
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageObject, error in
          guard let image = imageObject as? UIImage else { return }
            guard let data = image.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: data) else{return}
          DispatchQueue.main.async { [weak self] in
            self?.photosToBeScanned.append(compressedImage)
          }
        }
      }
    }

    
    
    // Search Places and puts result in placeArray
    func searchQuery(){
        
        places.removeAll()
        
        placesArray.removeAll()
        
        let request = MKLocalSearch.Request()
       // request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant, .airport, .foodMarket,.])
        request.region = region
        request.naturalLanguageQuery = currentInterest
        
        // Fetch
        MKLocalSearch(request: request).start{(respose, _) in
            guard let result = respose else{return}
            
            DispatchQueue.main.async {
                withAnimation(.easeInOut) {
                    self.region = result.boundingRegion
                }
            }

            self.places = result.mapItems.compactMap({(item) -> Place? in
                
                // -- Easy fix rn to get the places in places Array immediately
                self.placesArray.append(Place(place: item.placemark))
                print("This is the self place array \(self.placesArray)")
                // -- Easy fex
                
                return Place(place: item.placemark)
            })
        }
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
    
    // Updates the map to the region of the new interest selected
    func updateMapRegion(){
        
        guard let place = placesArray.first else{return}
        
//        let place = placesArray.first!
        searchTxt = ""
        withAnimation(.easeInOut){
            self.region = MKCoordinateRegion(center: place.place.location!.coordinate,
                                             latitudinalMeters: 5000,
                                             longitudinalMeters: 5000)
            
        }
        print("This is placs Array \(placesArray)")
    }
    
    // Toggle Interest List view
    func toogleInterstListView(){
        withAnimation(.easeInOut) {
            showInterestListView.toggle()
        }
    }
    
    // Classifying image for ML
    func classifyImage(currentImageName: UIImage) {
        //let currentImageName = photos[currentIndex]
        
       // guard let image = UIImage(named: currentImageName),
        let image = currentImageName
            guard let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
            return
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            //let result = results.map { (key, value) in
            //    return "\(key) = \(String(format: "%.2f", value * 100))%"
            //}.joined(separator: "\n")
            let result = results.first
            var stringOfResult = result?.key ?? "No result"
            if let index = (stringOfResult.range(of: ",")?.lowerBound)
            {
                stringOfResult = String(stringOfResult.prefix(upTo: index))
            }
            MLPhotoResults.append(stringOfResult)
        }
    }
    
    
    // Everything below has to do with the location of the user
    let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission(){
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.locationManager.stopUpdatingLocation()
        }
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
