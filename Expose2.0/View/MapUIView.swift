//
//  MapUIView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/18/22.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapUIView: View {
    
    // this will always crash when ran. I believe it is because the view is not getting any data yet from the environmentObject
    @EnvironmentObject var viewModel : MapUIViewModel
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.placesArray){ place in
                MapAnnotation(coordinate: place.place.location!.coordinate) {
                    ZStack {
                        LocationMapAnnotationView().environmentObject(viewModel)
                            .onTapGesture {
                                viewModel.showMoreInfoView = true
                                viewModel.moreInfoPlace = PlaceMarked(name: place.place.name ?? "No name", addressNumber: place.place.subThoroughfare ?? "No number" , streetName:  place.place.thoroughfare ?? "No street name", city: place.place.locality ?? "No city name", state: place.place.administrativeArea ?? "No State name", county: place.place.subAdministrativeArea ?? "No county", country: place.place.country ?? "No country", zipCode: place.place.postalCode ?? "No postal code" )
                            }
                    }
                    
                }
            }
                .ignoresSafeArea()
                .tint(.pink)
            
        }
       
    }
}

struct MapUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapUIView()
            .environmentObject(MapUIViewModel())
        //HomeView()
    }
}




