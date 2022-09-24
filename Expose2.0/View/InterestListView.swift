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
            ForEach(mapData.interestEntities){ result in
                if let interest = result.interest{
                    Button {
                        mapData.toogleInterstListView()
                        self.mapData.currentInterest = interest
                        // Searching Place
                        // You can use your delay time
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {self.mapData.searchQuery()
                            
                        }
                        
                    } label: {
                        
                        Text(interest)
                            .textCase(.uppercase)
                            .font(.headline)
                            .padding()
                        
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
            
        }
        .listStyle(PlainListStyle())
        .onAppear {
            mapData.getInterest()
        }
    }
}

struct InterestListView_Previews: PreviewProvider {
    static var previews: some View {
        InterestListView().environmentObject(MapUIViewModel())
    }
}
