//
//  InterestListView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/26/22.
//

import SwiftUI

struct InterestListView: View {
    @EnvironmentObject private var viewModel: MapUIViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.MLPhotoResults, id: \.self){ result in
                Button {
                    
                    viewModel.toogleInterstListView()
                    viewModel.currentInterest = result
                    //viewModel.selectAllPlaces(places: viewModel.places)
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
