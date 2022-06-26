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
    @State var showAlert: Bool = false
    @State var isNavActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 500)), count: 2)
                    LazyVGrid(
                        columns: gridItems, spacing: 20) {
                            ForEach(0..<mapData.photosToBeScanned.count, id: \.self) { i in
                                Image(uiImage: mapData.photosToBeScanned[i])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                                    .clipped()
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
                .navigationTitle("Photos")
                .navigationBarItems(
                    trailing:
                        trailingButtons
                )
                    Spacer()
                    if mapData.photosToBeScanned.isEmpty{
                        Button {
                            mapData.isShowingImagePicker.toggle()
                        } label: {
                            ScanPhoto().environmentObject(mapData)
                                .foregroundColor(Color("BackGroundColor"))
                                .tint(.black)
                        }
                    }else{
                        NavigationLink(isActive: $mapData.isNavActive) {
                            ResultsView(changeScreens: $changeScreens).environmentObject(mapData)
                        } label: {
                            
                            ScanPhoto().environmentObject(mapData)
                                .foregroundColor(/*@START_MENU_TOKEN@*/Color("BackGroundColor")/*@END_MENU_TOKEN@*/)
                                .onTapGesture {
                                    if !mapData.photosToBeScanned.isEmpty{
                                        mapData.isNavActive = true
                                    }
                                }
                        }
                    }
            }
        }
        .onAppear{mapData.isShowingImagePicker = true}
        
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
    @EnvironmentObject var mapData : MapUIViewModel
    var body: some View{
        VStack {
            Text(mapData.photosToBeScanned.isEmpty ? "ADD MY PHOTOS" : "SCAN MY PHOTOS" )
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
