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
    @EnvironmentObject var mapData : MapUIViewModel
    
    var body: some View {
        
        ZStack {
            // Using it as environment object so that it can  used in subviews...
            MapUIView().environmentObject(mapData)
            VStack{
                header
                
                Spacer()
                LocationAndGlobeButton().environmentObject(mapData)
            }
            MoreInfoView(isShowing: $mapData.showMoreInfoView)
                .environmentObject(mapData)
        }
        .onChange(of: mapData.currentInterest, perform:{ value in
            
            // Searching Place
            // You can use your delay time
            let delay = 0.1
            print("This is value \(value)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.currentInterest{
                    print("So it is getting here")
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

struct LocationAndGlobeButton: View {
    @EnvironmentObject var mapData : MapUIViewModel
    var body: some View {
        VStack{
            LocationButton(.currentLocation){
                mapData.requestAllowOnceLocationPermission()
            }
            .scaledToFill()
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            //.labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .tint(.black)
            
            
        }
        // Quick solution to get the map to update region
        .onChange(of: mapData.placesArray, perform:{ newValue in
            if newValue == mapData.placesArray{
                print("Gets here first?")
                mapData.updateMapRegion()
            }
        })
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

extension HomeView{
    private var header: some View{
        VStack{
            Button {
                mapData.toogleInterstListView()
            } label: {
                Text(mapData.currentInterest)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .textCase(.uppercase)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: mapData.showInterestListView ? 180: 0))
                    }
            }
            
            
            if mapData.showInterestListView{
                InterestListView()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
        .padding()
    }
}
