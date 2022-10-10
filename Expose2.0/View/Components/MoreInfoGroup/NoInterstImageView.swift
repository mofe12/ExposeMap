//
//  NoInterstImageView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/8/22.
//

import SwiftUI

struct NoInterestImageView: View {
    var body: some View {
        HStack{
        ForEach(0..<2) { _ in
                Rectangle()
                    .frame(width: 185, height: 250)
                    .overlay {
                        VStack {
                            Image(systemName: "photo.on.rectangle.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 40, height: 30)
                            Text("Image Unavailable")
                                .font(.caption)
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Text("Yelp")
                            .font(.caption)
                            .padding(5)
                            .background(.black.opacity(0.1))
                            .cornerRadius(2)
                    }
                    .opacity(0.2)
                    .cornerRadius(20)
                    
            }
        }
        
    }
}

struct NoInterstImageView_Previews: PreviewProvider {
    static var previews: some View {
        NoInterestImageView()
    }
}
