//
//  InterestListView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/26/22.
//

import SwiftUI

struct InterestListView: View {
    @EnvironmentObject private var mapData: MapUIViewModel
    
    var body: some View {
        List {
            ForEach(mapData.MLPhotoResults, id: \.self){ result in
                Button {
                    
                    mapData.toogleInterstListView()
                    mapData.currentInterest = result
                    //viewModel.updateMapRegion(places: viewModel.placesArray)
                } label: {
                    Text(result)
                        .textCase(.uppercase)
                        .font(.headline)
                        .padding()
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .listRowBackground(Color.clear)
                
        }
        .listStyle(PlainListStyle())

        
    }
}

struct InterestListView_Previews: PreviewProvider {
    static var previews: some View {
        InterestListView().environmentObject(MapUIViewModel())
    }
}
