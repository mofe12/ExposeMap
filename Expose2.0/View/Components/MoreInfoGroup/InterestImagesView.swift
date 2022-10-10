//
//  InterestImagesView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/8/22.
//

import SwiftUI

struct InterestImagesView: View{
    @EnvironmentObject var mapData: MapUIViewModel
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            photos
        }
    } // MARK: VIEW
    
    var photos: some View{
        HStack {
            if let photos = mapData.YelpBusDetail?.photos,
               !photos.isEmpty{
                    ForEach(photos, id: \.self) { photo in
                        DownloadingImageView(url: photo)
                    }
            }else{
                NoInterestImageView()
            }
        }
        .padding(.horizontal)
    }
    
}

struct InterestImagesView_Previews: PreviewProvider {
    static var previews: some View {
        InterestImagesView()
            .previewLayout(.sizeThatFits)
            .environmentObject(MapUIViewModel())
    }
}
