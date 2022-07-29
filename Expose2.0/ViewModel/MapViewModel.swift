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
    
    @Published var photoToScanCheck: [UIImage] = []
    
    // File managing
    static let shared = DataProvider()
    
    private let dataSourceURL: URL
    
    @Published var allInterest = Interest(Interests: [], photos: [])
    
    //Current Page
    @Published var currentPage = changeScreen.contentView
    
    @Published var isNavActive: Bool = false
    
    @Published var OnBoardingStepArray: [OnBoardingStep] = [
        OnBoardingStep(Image: "heart.fill", Text: "WE CARE ABOUT PRIVACY!"),
        OnBoardingStep(Image: "nosign", Text: "Exposé DOES NOT keep or share any of your photos or information with any third parties nor do we store it!"),
        OnBoardingStep(Image: "lasso.and.sparkles", Text: "We only use your photos to curate your interest and give you options of places to get exposed to around you! That's it!"),
    ]
    
    // Setting Region
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -95), latitudinalMeters: 10000000, longitudinalMeters: 10000000)
    
    // Map type
    @Published var mapType: MKMapType = .standard
    
    // MapView permissions
    
    enum locationPermissionsEnum{
        case allow
        case notAllowed
    }
    @Published var locationPermission: locationPermissionsEnum = .allow
    
    @Published var alertValue: Bool = false
    
    struct AlertStruct{
        var title: String
        var message: String
    }
    
    @Published var alertDetail = AlertStruct(title: "" , message: "")
    
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
    
    // Photos to be scanned by the ML
    
    // Showing image picker
    @Published var isShowingImagePicker = false
    
    // Gotten File Manager
    @Published var FileManagerData: Interest = Interest(Interests: [], photos: [])
    // Photos to be saved
    
    @Published var newPhotosToBeScanned: [UIImage] = []
    
    
    @Published var scannedPhotoToBeSaved: [String] = []
    
    @Published var selectedPhotoToShow: [UIImage] = []
    
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
    
    
    // Handle result
    func handleResults(_ results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageObject, error in
                guard let image = imageObject as? UIImage else { return }
                guard let data = image.jpegData(compressionQuality: 0.0), let compressedImage = UIImage(data: data) else{return}
                DispatchQueue.main.async { [weak self] in
                    self?.newPhotosToBeScanned.append(compressedImage)
                    self?.selectedPhotoToShow.append(compressedImage)
                }
            }
        }
    }
    
    
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
    
    // Classifying image for ML
    func classifyImage(currentImageName: UIImage) {
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
            // Making sure interest does not repeat itself
            if !MLPhotoResults.contains(stringOfResult){
                NewMLPhotoResults.append(stringOfResult)
                MLPhotoResults.append(stringOfResult)
                
            // Changing UIImage into String
                changeUIImageToString(currentImageName)
            }
        }
    }
    
    
    // All about Locations part
    var locationManager: CLLocationManager?
    
    func checkIfLocationServiceIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationPermission = .allow
        }else{
            locationPermission = .notAllowed
            alertDetail = AlertStruct(title: "Location Disabled", message: "Your location is off, turn on to use app")
            alertValue = true
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager1 = locationManager else { return }
        
        
        switch locationManager1.authorizationStatus{
            
        case .notDetermined:
            locationManager1.requestWhenInUseAuthorization()
            locationPermission = .allow
            
        case .restricted:
            locationPermission = .notAllowed
            alertDetail = AlertStruct(title: "Restricted Location", message: "Your current location can’t be determined because it is restricted. For great experience, Allow Exposé to use your location.\n Select \"While Using the App.\"")
            alertValue = true
            
        case .denied:
            locationPermission = .notAllowed
            alertDetail = AlertStruct(title: "Denied Location", message: "You have DENIED the app location, go to settings to change it. For great experience, allow Exposé to use your location.\n Select \"While Using the App.\"")
            alertValue = true
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationPermission = .allow
            DispatchQueue.main.async {
                withAnimation(.easeInOut) {
                    self.region = MKCoordinateRegion(center: locationManager1.location!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                }
            }
        @unknown default:
            break
        }
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func updateMapRegion(){
        guard let locationManager1 = locationManager else { return }
        
        print("LOCATION PERMISSION: \(locationPermission)")
        if locationPermission == .notAllowed{
            alertValue = true
        }else{
            withAnimation(.easeInOut) {
                self.region = MKCoordinateRegion(center: locationManager1.location!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            }
        }
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
