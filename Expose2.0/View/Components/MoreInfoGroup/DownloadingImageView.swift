//
//  DownloadingImageView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/8/22.
//

import SwiftUI

struct DownloadingImageView: View {
    @StateObject var vm: DownloadingImageViewModel
    init(url: String)
    {
        _vm = StateObject(wrappedValue: DownloadingImageViewModel(urlString: url))
    }
    var body: some View {
        ZStack{
            if vm.isLoading{
                ProgressView()
                    .frame(width: 185, height: 250)
            }else{
                if let image = vm.image{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 185, height: 250)
                        .overlay(alignment: .bottomTrailing) {
                            Text("Yelp")
                                .font(.caption)
                                .padding(5)
                                .background(.black.opacity(0.1))
                                .cornerRadius(2)
                        }
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct DownloadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImageView(url: "https://s3-media3.fl.yelpcdn.com/bphoto/1whNw_nOp6KxLfEMFThVJw/o.jpg")
            .frame(width: 185, height: 250)
            .previewLayout(.sizeThatFits)
    }
}
