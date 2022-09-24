//
//  Bubbles.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/20/22.
//

import SwiftUI

struct BubblesComp: View {
    var image: UIImage
    var text: String
    var body: some View {
        HStack {
            if let image =  UIImage(data:image.jpegData(compressionQuality: 5.0)!){
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                .clipped()
            }
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Image("MapBack")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .blur(radius: 15))
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: Color(.systemGray6), radius: 10, x: 0, y: 10)
        
    }
}

struct BubblesComp_Previews: PreviewProvider {
    static var previews: some View {
        BubblesComp(image: UIImage(named: "ballet")!, text: "Lemon")
    }
}
