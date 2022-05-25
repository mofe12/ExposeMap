//
//  HomeView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/16/22.
//

import SwiftUI
import CoreLocation
import MapKit
import CoreLocationUI

struct HomeView: View {
    @StateObject var mapData = MapUIViewModel()
    
    var body: some View {
        
        ZStack {
            // Using it as environment object so that it can  used in subviews...
            MapUIView().environmentObject(mapData)
            VStack{
                VStack(spacing: 0){
                    SearchBar().environmentObject(mapData)
                }
                .padding()
                Spacer()
                LocationAndGlobeButton().environmentObject(mapData)
            }
            MoreInfoView(isShowing: $mapData.showMoreInfoView)
                .environmentObject(mapData)
        }
        .onChange(of: mapData.searchTxt, perform:{ value in
            
            // Searching Place
            
            // You can use your
            let delay = 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchTxt{
                     
                    // Search...
                    self.mapData.searchQuery()
                }
            }
            
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(MapUIViewModel())
    }
}

struct SearchBar: View {
    @EnvironmentObject var mapData : MapUIViewModel
    var body: some View {
        HStack{
            Image (systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Putting all the
            TextField("Search", text: $mapData.searchTxt)
                .colorScheme(.light)
                .onSubmit {
                    //mapData.updateMapRegion(places: mapData.places)
                    mapData.selectAllPlaces(places: mapData.places)
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(6)
        
        
        // Displaying results
        if !mapData.places.isEmpty && mapData.searchTxt != ""{
            ScrollView{
                VStack(spacing: 15){

                    //mapData.selectAllPlaces(places: mapData.places)
                    ForEach(mapData.places){place in

                        Text(place.place.name ?? "")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .onTapGesture {
                                mapData.selectPlace(place: place)
                            }
                        Divider()

                    }
                }
                .padding(.top)
            }
            .background(.white)
        }
    }
}

struct LocationAndGlobeButton: View {
    @EnvironmentObject var mapData : MapUIViewModel
    var body: some View {
        VStack{
            LocationButton(.currentLocation){
                mapData.requestAllowOnceLocationPermission()
            }
            .scaledToFill()
            .foregroundColor(.white)
            .clipShape(Circle())
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .tint(.black)
            
            .frame(width: 50, height: 50)
            
            
            
            Button {
                mapData.updateMapType()
            } label: {
                Image(systemName: mapData.mapType == .standard ? "network": "map")
                    .font(.title3)
                    .padding(10)
                    .background(Color.primary)
                    .clipShape(Circle())
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
    }
}
