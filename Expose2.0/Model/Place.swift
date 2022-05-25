//
//  Place.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/16/22.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
   // var images : [String?]
    var place: CLPlacemark
}


struct PlaceMarked: Identifiable{
    var id = UUID().uuidString
    var name : String?
    var addressNumber: String?
    var streetName: String? // thoroughfare
    var city: String? // Locality
    var state: String? // administrativeArea
    var county: String? //subAdministrativeArea
    var country: String?
    var zipCode: String? //postal code
    
    
    
//    var thoroughfare: String?// street name, eg. Infinite Loop
//    
//    var subThoroughfare: String? // eg. 1
//
//    var locality: String? // city, eg. Cupertino
//
//    var subLocality: String?// neighborhood, common name, eg. Mission District
//
//    var administrativeArea: String?// state, eg. CA
//
//    var subAdministrativeArea: String?// county, eg. Santa Clara
//
//    var postalCode: String?// zip code, eg. 95014
//
//    var isoCountryCode: String?// eg. US
//
//    var country: String?// eg. United States
//
//    var inlandWater: String?// eg. Lake Tahoe
//
//    var ocean: String?// eg. Pacific Ocean

    
}
