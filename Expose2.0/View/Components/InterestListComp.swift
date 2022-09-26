//
//  InterestListComp.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/24/22.
//

import SwiftUI

struct InterestListComp: View {
    var image: UIImage
    var interest: String
    var body: some View {
        HStack{ 
            if let image = image.jpegData(compressionQuality: 0.5){
                Image(uiImage: UIImage(data: image) ?? UIImage(systemName: "questionmark.circle.fill")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(interest)
                    .textCase(.uppercase)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct InterestListComp_Previews: PreviewProvider {
    static var previews: some View {
        InterestListComp(image: UIImage(named: "ballet")!, interest: "Lemon")
    }
}
