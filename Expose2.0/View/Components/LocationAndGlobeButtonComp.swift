//
//  LocationAndGlobeButtonComp.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/19/22.
//

import SwiftUI

struct LocationAndGlobeButtonComp: View {
    @EnvironmentObject var mapData : MapUIViewModel
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing:0) {
                NavigationLink(destination: AddPhotoView(), isActive: $mapData.showPhotoScreen) {
                    Image(systemName: "photo.fill")
                        .frame(maxWidth:  .infinity, maxHeight: .infinity)
                        .padding(.bottom, 1)
                        .foregroundColor(.primary)
                }
                .onTapGesture {
                    mapData.showPhotoScreen.toggle()
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

struct LocationAndGlobeButtonComp_Previews: PreviewProvider {
    static var previews: some View {
        LocationAndGlobeButtonComp()
    }
}
