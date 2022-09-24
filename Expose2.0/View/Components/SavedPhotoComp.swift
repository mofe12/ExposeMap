//
//  GettingPhotosView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 8/18/22.
//

import SwiftUI


enum groupType{
    case selectedPhoto
    case gottenImage
}
struct SavedPhotoComp: View {
    
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
                    viewModel.deleteInterest(interestID: interestId)
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
    struct GettingPhotosView_Previews: PreviewProvider {
        static var previews: some View {
            SavedPhotoComp(photo: UIImage(named: "basketball")!, interestId: UUID(), viewModel: PhotoPickerViewModel())
        }
    }
