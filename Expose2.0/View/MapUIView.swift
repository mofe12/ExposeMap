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
    @EnvironmentObject var viewModel : MapUIViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.places){ place in
            MapAnnotation(coordinate: place.place.location!.coordinate) {
                //LocationMapAnnotationView().environmentObject(viewModel)
                ZStack {
                    Image(systemName: "mappin")
                        .font(.title)
                        .onTapGesture {
                            viewModel.showMoreInfoView = true
                            viewModel.moreInfoPlace = PlaceMarked(name: place.place.name ?? "",
                                                                  addressNumber: place.place.subThoroughfare ?? "",
                                                                  streetName:  place.place.thoroughfare ?? "",
                                                                  city: place.place.locality ?? "",
                                                                  state: place.place.administrativeArea ?? "",
                                                                  county: place.place.subAdministrativeArea ?? "",
                                                                  country: place.place.country ?? "",
                                                                  zipCode: place.place.postalCode ?? "")
                        }
                }
            }
        }
        .onAppear{
            viewModel.locationManagerService.checkIfLocationServiceIsEnabled()
        }
        .ignoresSafeArea()
        
    }
}

struct MapUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapUIView()
            .environmentObject(MapUIViewModel())
    }
}




