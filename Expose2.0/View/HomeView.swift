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
    @Binding var changeScreens: changeScreen
    
    var body: some View {
        ZStack {
            // Using it as environment object so that it can  used in subviews...
            MapUIView().environmentObject(mapData)
                .alert(isPresented: $mapData.alertValue) {
                    Alert(
                        title: Text(mapData.alertDetail.title),
                        message: Text(mapData.alertDetail.message)
                    )
                }
            if mapData.showInterestListView{
                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        mapData.toogleInterstListView()
                    }
            }
            VStack{
                header
                Spacer()
                HStack{
                    Button {
                        print(mapData.locationPermission)
                    } label: {
                        Text("Click me")
                    }
                    Spacer()
                    
                    LocationAndGlobeButton(changeScreens: $changeScreens).environmentObject(mapData)
                }
                
            }
            MoreInfoView(isShowing: $mapData.showMoreInfoView)
                .environmentObject(mapData)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(changeScreens: .constant(changeScreen.contentView))
            .environmentObject(MapUIViewModel())
    }
}

struct LocationAndGlobeButton: View {
    @EnvironmentObject var mapData : MapUIViewModel
    @Binding var changeScreens: changeScreen
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing:0) {
                Button {
                    changeScreens = .photoSelectedView
                    mapData.isNavActive = false
                } label: {
                    Image(systemName: "photo.fill")
                        .frame(maxWidth:  .infinity, maxHeight: .infinity)
                        .padding(.bottom, 1)
                        .foregroundColor(.primary)
                }
                Divider()
                    .frame(width: 59)
                ZStack {
                    Button {
                        mapData.locationPermission != .allow ? mapData.alertValue = true : mapData.locationManagerService.updateMapRegion()
                    } label: {
                        Image(systemName:"location.fill")
                            .frame(maxWidth:  .infinity, maxHeight: .infinity)
                            .foregroundColor(.primary)
                            .padding(.top, 1)
                    }
                }
            }
            .font(.title2)
            .frame(width: 50, height: 120)
            .background(.thickMaterial)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
        }
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
                    .frame(height: 400)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
        .padding(.horizontal)
    }
}
