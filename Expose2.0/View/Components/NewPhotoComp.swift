//
//  NewPhotoComp.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/17/22.
//

import SwiftUI

struct NewPhotoComp: View {
    
    var photo: UIImage
    var interestId: UUID
    @ObservedObject var viewModel: PhotoPickerViewModel
    
    var body: some View {
        
        Rectangle()
            .overlay(alignment: .center) {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
            }
            .overlay(alignment: .bottomTrailing){
                Button {
                    viewModel.deleteInterest(from: interestId)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                        .padding(.trailing, 10)
                        .padding(.bottom,10)
                }
            }
            .frame(height: 150)
            .clipped()
    }
    
}

struct NewPhotoComp_Previews: PreviewProvider {
    static var previews: some View {
        NewPhotoComp(photo: UIImage(named: "basketball")!, interestId: UUID(), viewModel: PhotoPickerViewModel())
    }
}
