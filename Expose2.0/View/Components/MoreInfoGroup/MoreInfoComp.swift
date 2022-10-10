//
//  MoreInfoComp.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/30/22.
//

import SwiftUI

struct MoreInfoComp: View {
    @EnvironmentObject var mapData: MapUIViewModel
    var body: some View {
        ZStack(){
            LazyVStack(alignment: .leading) {
                HStack {
                    Text(mapData.moreInfoPlace.name!)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .padding(.top)
                    
                    Spacer()
                    Button {
                        openAppleMaps()
                    } label: {
                        (Text("Navigation " ) + Text(Image(systemName: "arrow.right")))
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color("Turquoise"))
                            .cornerRadius(50)
                    }

                }
                .padding(.horizontal)
                .padding(.top)
                Address
                Divider()
                    .padding(.horizontal)
                InterestImagesView()
                    .padding(.top, 5)
  
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    } // MARK: VIEW
    
    
    var Address: some View {
        return Text("\(mapData.moreInfoPlace.addressNumber!) \(mapData.moreInfoPlace.streetName!) \(mapData.moreInfoPlace.city!), \(mapData.moreInfoPlace.state!) \(mapData.moreInfoPlace.zipCode!) \(mapData.moreInfoPlace.country!)")
            .padding(.horizontal)
    }
    
    
    
    func openAppleMaps(){
        guard let url = URL(string: "maps://?saddr=&daddr=\(mapData.moreInfoPlace.location.coordinate.latitude),\(mapData.moreInfoPlace.location.coordinate.longitude)") else {return}
        
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct MoreInfoComp_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoComp()
            .environmentObject(MapUIViewModel())
    }
}



