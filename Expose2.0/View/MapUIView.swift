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
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.placesArray){ place in
                MapAnnotation(coordinate: place.place.location!.coordinate) {
                        //LocationMapAnnotationView().environmentObject(viewModel)
                    
                    ZStack {
                        Image(systemName: "mappin")
                            .font(.title)
                                    .onTapGesture {
                                        viewModel.showMoreInfoView = true
                                        viewModel.moreInfoPlace = PlaceMarked(name: place.place.name ?? "No name",
                                                                              addressNumber: place.place.subThoroughfare ?? "No number",
                                                                              streetName:  place.place.thoroughfare ?? "No street name",
                                                                              city: place.place.locality ?? "No city name",
                                                                              state: place.place.administrativeArea ?? "No State name",
                                                                              county: place.place.subAdministrativeArea ?? "No county",
                                                                              country: place.place.country ?? "No country",
                                                                              zipCode: place.place.postalCode ?? "No postal code")
                                }
                    }
                }
            }
            .onAppear{
                viewModel.checkIfLocationServiceIsEnabled()
                
                //viewModel.FileManagerData = viewModel.get()
                //viewModel.changeStringToUIImage(viewModel.FileManagerData.photos)
//                print("\n\nSAVED INTEREST \(fileManInt.Interests)\nSAVED PHOTOS \( viewModel.changeStringToUIImage(fileManInt.photos))\n\n")
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
    }
}




