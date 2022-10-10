//
//  AddPhotoScreen.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/17/22.
//

import SwiftUI

struct AddPhotoView: View {
    @StateObject var viewModel = PhotoPickerViewModel()
    @EnvironmentObject var mapData : MapUIViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isNavActive = false
    var body: some View {
            VStack{
                ScrollView{
                    if !viewModel.selectedPhotoToShow.isEmpty{
                        Text("New Images")
                            .bold()
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        Divider()
                            .frame(width: 350)
                        
                        LazyVGrid(columns: viewModel.COLUMN, spacing: 20) {
                            ForEach(viewModel.selectedPhotoToShow) { item in
                                if let photos = item.photos,
                                   let image = UIImage(data: photos){
                                    NewPhotoComp(photo: image, interestId: item.id, viewModel: viewModel)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    if !viewModel.interestEntities.isEmpty
                    {
                        Text("Scanned Images")
                            .bold()
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        Divider()
                            .frame(width: 350)
                    }
                    
                    LazyVGrid(columns: viewModel.COLUMN, spacing: 20) {
                        ForEach(viewModel.interestEntities) { item in
                            if let picture = item.image,
                               let image = UIImage(data: picture),
                               let id = item.interestID {
                                SavedPhotoComp(photo: image, interestId: id, viewModel: viewModel)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                }
                if viewModel.selectedPhotoToShow.isEmpty {
                    ButtonTurView(text: "ADD YOUR PHOTOS")
                        .onTapGesture {
                            viewModel.isShowingImagePicker.toggle()
                        }
                }else{
                    NavigationLink(destination: ProtoResultView(photoPickerModel: viewModel), isActive: $isNavActive) {
                        ButtonTurView(text: "SCAN YOUR PHOTOS")
                            .onTapGesture {
                                viewModel.navActive.toggle()
                            }
                    }
                    .sync($viewModel.navActive, with: $isNavActive)
                    //.environmentObject(viewModel)
                }
                
                
            }
            .onAppear(perform: {
                viewModel.getInterest()
                viewModel.isShowingImagePicker.toggle()
            })
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                PhotoPickerUIKitView(isPresented: $viewModel.isShowingImagePicker) {
                    viewModel.handleResults($0) }
            }
            
            
            
            
            
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        mapData.showPhotoScreen.toggle()
                    } label: {
                        Text("Cancel")
                    }
                    .foregroundColor(Color("Turquoise"))
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.isShowingImagePicker.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .foregroundColor(Color("Turquoise"))
                }
            }.navigationBarBackButtonHidden(true)
    }
}

struct AddPhotoScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView()
            .environmentObject(PhotoPickerViewModel())
    }
}
