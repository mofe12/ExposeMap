//
//  PhotoSelectedView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/31/22.
//

import SwiftUI

struct PhotoSelectedView: View {
    @EnvironmentObject var mapData : MapUIViewModel
    
    @State var userInterest: [AppInterest] = []
    @StateObject var photoPickerModel = PhotoPickerViewModel()
    @Binding var changeScreens: changeScreen
    @State var isNavActive: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20, alignment: nil),
        GridItem(.flexible(), spacing: 20, alignment: nil)
    ]
    var body: some View {
        
        NavigationView {
            VStack {
                ScrollView{
                    if !photoPickerModel.selectedPhotoToShow.isEmpty{
                        Text("New Images")
                            .bold()
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        Divider()
                            .frame(width: 350)
                    }
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<photoPickerModel.selectedPhotoToShow.count, id: \.self) { i in
                            if let photo = photoPickerModel.selectedPhotoToShow[i].photos,
                               let image = UIImage(data: photo)
                            {
                               // GettingPhotosView(photo: image, viewModel: photoPickerModel)
                                   // .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if !photoPickerModel.gottenInterest.isEmpty
                    {
                        Text("Saved Images")
                            .bold()
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        Divider()
                            .frame(width: 350)
                    }
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<photoPickerModel.gottenInterest.count, id: \.self) { i in
                            if let photo = photoPickerModel.gottenInterest[i].photos,
                               let image = UIImage(data: photo)
                            {
                             //   GettingPhotosView(photo: image, viewModel: photoPickerModel)
                                    //.clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Photos")
                .navigationBarItems(
                    trailing:
                        trailingButtons
                )
                
                
                if (photoPickerModel.selectedPhotoToShow.isEmpty && photoPickerModel.gottenInterest.isEmpty){
                    Button {
                        photoPickerModel.isShowingImagePicker.toggle()
                    } label: {
                        ButtonTurView(text: "Add My Photos")
                    }
                }else{
                    NavigationLink(isActive: $mapData.isNavActive) {
                        ProtoResultView(photoPickerModel: photoPickerModel)
                    } label: {
                        
                        ButtonTurView(text: "Scan My Photos")
                            .onTapGesture {
                                userInterest = photoPickerModel.classifyAllImages(photoPickerModel.selectedPhotoToShow)
                                mapData.isNavActive = true
                                
                            }
                    }
                }
            }
        }
        .environmentObject(photoPickerModel)
        .sheet(isPresented: $photoPickerModel.isShowingImagePicker) {
            PhotoPickerUIKitView(isPresented: $photoPickerModel.isShowingImagePicker) {
                photoPickerModel.handleResults($0)
            }
        }
        .onAppear{
            photoPickerModel.isShowingImagePicker.toggle()      
        }
    }
    
    private var trailingButtons: some View {
        HStack {
            Button(action: {
                photoPickerModel.isShowingImagePicker.toggle() }) {
                    Image(systemName: "plus.circle")
                }
                .foregroundColor(Color("Turquoise"))
        }
    } // MARK: TrailingButton
}

struct PhotoSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectedView(changeScreens: .constant(changeScreen.contentView)).environmentObject(MapUIViewModel())
    }
}
