//
//  ProtoPhotoSelectorView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/17/22.
//

import SwiftUI

struct ProtoPhotoSelectorView: View {
    @AppStorage("onBoarding") var onBoarding =  0
    @StateObject var viewModel = PhotoPickerViewModel()
    @EnvironmentObject var mapData : MapUIViewModel

    
    var body: some View {
        NavigationView {
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
                            Text("Saved Images")
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
                .navigationTitle("Photos")
                .navigationBarItems(
                    trailing: trailingButton
                )

                
                if (viewModel.selectedPhotoToShow.isEmpty && viewModel.interestEntities.isEmpty){
                    ButtonTurView(text: "ADD MY PHOTOTS")
                        .onTapGesture {
                            viewModel.isShowingImagePicker.toggle()
                        }
                }else{
                    NavigationLink(isActive: $mapData.isNavActive) {
                        ProtoResultView(photoPickerModel: viewModel)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        ButtonTurView(text: "SCAN MY PHOTOS")
                    }

                }
            }
            .onAppear {
                DispatchQueue.global(qos: .background).async {
                    viewModel.getInterest()
                }
                viewModel.isShowingImagePicker = true
            }
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $viewModel.isShowingImagePicker) {
            PhotoPickerUIKitView(isPresented: $viewModel.isShowingImagePicker) {
                viewModel.handleResults($0) }
        }
    }
}

struct ProtoPhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProtoPhotoSelectorView()
    }
}


extension ProtoPhotoSelectorView{
    var trailingButton: some View{
        HStack {
            Button(action: {
                viewModel.isShowingImagePicker.toggle() }) {
                    Image(systemName: "plus.circle")
                }
                .foregroundColor(Color("Turquoise"))
        }
    }
}
