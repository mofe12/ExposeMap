//
//  PhotoSelectedView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/31/22.
//

import SwiftUI

struct PhotoSelectedView: View {
    @EnvironmentObject var mapData : MapUIViewModel
    @Binding var changeScreens: changeScreen
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(175), spacing: 10), count: 2)) {
                        ForEach(0..<mapData.photosToBeScanned.count, id: \.self) { i in
                            Image(uiImage: mapData.photosToBeScanned[i])
                                .resizable()
                                .scaledToFill()
                                .overlay( Button {
                                    mapData.photosToBeScanned.remove(at: i)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.red)
                                }, alignment: .bottomTrailing
                                          
                                )
                        }
                    }
            }
            .navigationTitle("Canvas")
            .navigationBarItems(
                trailing:
                    trailingButtons
            )
        }
        .sheet(isPresented: $mapData.isShowingImagePicker) {
            PhotoPickerUIKitView(isPresented: $mapData.isShowingImagePicker) {
                mapData.handleResults($0)
            }
        }
    }
    private var trailingButtons: some View {
        HStack {
            Button(action: { mapData.isShowingImagePicker.toggle() }) {
                Image(systemName: "plus.circle")
            }
            NavigationLink {
                ResultsView(changeScreens: $changeScreens).environmentObject(mapData)
            } label: {
                
                    Image(systemName: "chevron.right.2")
                
            }

        }
    }
}

struct PhotoSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectedView(changeScreens: .constant(changeScreen.contentView)).environmentObject(MapUIViewModel())
    }
}
