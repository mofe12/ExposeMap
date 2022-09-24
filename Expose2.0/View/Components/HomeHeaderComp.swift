//
//  HomeHeaderComp.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/24/22.
//

import SwiftUI

struct HomeHeaderComp: View {
    @EnvironmentObject var mapData : MapUIViewModel
    var body: some View {
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

struct HomeHeaderComp_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderComp()
            .environmentObject(MapUIViewModel())
    }
}
