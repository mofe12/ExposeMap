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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -95), latitudinalMeters: 10000000, longitudinalMeters: 10000000)

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.places){ place in
            MapAnnotation(coordinate: place.place.location!.coordinate) {
                //LocationMapAnnotationView().environmentObject(viewModel)
                ZStack {
                    Image(systemName: "mappin")
                        .font(.title)
                        .padding()
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
        .onReceive(viewModel.$region, perform: { region in
            // Prevent animation on map to show when opening app for the first time
            if viewModel.regionButtonClicked{
                withAnimation(.default) {
                    self.region = region
                }
            }else{self.region = region}
            
        })
        .onAppear{
            viewModel.locationManagerService.checkIfLocationServiceIsEnabled()
            viewModel.getInterest()
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




