//
//  PhotoSelectedView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/31/22.
//

import SwiftUI

struct PhotoSelectedView: View {
    @EnvironmentObject var mapData : MapUIViewModel
    
    @StateObject var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel()
    @Binding var changeScreens: changeScreen
    @State var showAlert: Bool = false
    @State var isNavActive: Bool = false
    
    @State var imageClassificationResult: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 500)), count: 2)
                    LazyVGrid(
                        columns: gridItems, spacing: 20) {
                            ForEach(0..<photoPickerModel.selectedPhotoToShow.count, id: \.self) { i in
                                Image(uiImage: photoPickerModel.selectedPhotoToShow[i])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                                    .clipped()
                                    .overlay( Button {
                                        photoPickerModel.selectedPhotoToShow.remove(at: i)
                                        
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.red)
                                    }, alignment: .bottomTrailing
                                              
                                    )
                            }
                        }
                }
                .navigationTitle("Photos")
                .navigationBarItems(
                    trailing:
                        trailingButtons
                )
                    Spacer()
                if (photoPickerModel.selectedPhotoToShow.isEmpty && photoPickerModel.newPhotosToBeScanned.isEmpty){
                        Button {
                            photoPickerModel.isShowingImagePicker.toggle()
                        } label: {
                            ScanPhoto(photoPickerModel: photoPickerModel)
                                .foregroundColor(Color("BackGroundColor"))
                                .tint(.black)
                        }
                    }else{
                        NavigationLink(isActive: $mapData.isNavActive) {
                            ResultsView(classificationResult: imageClassificationResult,changeScreens: $changeScreens).environmentObject(mapData)
                        } label: {
                            
                            ScanPhoto(photoPickerModel: photoPickerModel)
                                .foregroundColor(/*@START_MENU_TOKEN@*/Color("BackGroundColor")/*@END_MENU_TOKEN@*/)
                                .onTapGesture {
                                    guard let result = photoPickerModel.classifyAllImages(photoPickerModel.newPhotosToBeScanned)else{return}
                                    
                                    if (!photoPickerModel.selectedPhotoToShow.isEmpty || !photoPickerModel.newPhotosToBeScanned.isEmpty){
                                        mapData.isNavActive = true
                                        
                                    }
                                    
                                    print("PHOTOTOSCANCHECK: \(photoPickerModel.photoToScanCheck)\n NEWPHOTOTOSCAN: \(photoPickerModel.newPhotosToBeScanned)")
                                    if photoPickerModel.photoToScanCheck != photoPickerModel.newPhotosToBeScanned{
                                        photoPickerModel.photoToScanCheck = photoPickerModel.newPhotosToBeScanned
                                       
                                            imageClassificationResult = result
                                        
                                        
                                    }
                                    
                                }
                        }
                    }
            }
            .onAppear{photoPickerModel.isShowingImagePicker = true
                print("\n\nPHOTO SELECTED NUMBER: \(photoPickerModel.newPhotosToBeScanned.count)\n")
                
                photoPickerModel.newPhotosToBeScanned = []
                mapData.scannedPhotoToBeSaved = []
                mapData.NewMLPhotoResults = []
                
            }
        }
        
        
        .sheet(isPresented: $photoPickerModel.isShowingImagePicker) {
            PhotoPickerUIKitView(isPresented: $photoPickerModel.isShowingImagePicker) {
                photoPickerModel.handleResults($0)
            }
        }
    }
    private var trailingButtons: some View {
        HStack {
            Button(action: { photoPickerModel.isShowingImagePicker.toggle() }) {
                Image(systemName: "plus.circle")
            }
            .foregroundColor(Color("Turquoise"))
        }
    }
}

struct PhotoSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectedView(changeScreens: .constant(changeScreen.contentView)).environmentObject(MapUIViewModel())
    }
}
struct ScanPhoto: View{
    var photoPickerModel: PhotoPickerViewModel
    var body: some View{
        VStack {
            Text(photoPickerModel.selectedPhotoToShow.isEmpty && photoPickerModel.newPhotosToBeScanned.isEmpty ? "ADD MY PHOTOS" : "SCAN MY PHOTOS" )
                .foregroundColor(.primary)
                .font(.title2)
                .fontWeight(.black)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color("Turquoise"))
                .cornerRadius(16)
                .padding(.horizontal, 16)
        }
    }
}
