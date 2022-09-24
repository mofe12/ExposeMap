//
//  ProtoResultView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/16/22.
//

import SwiftUI

struct ProtoResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("onBoarding") var onBoarding = 0
    @StateObject var viewModel = ResultPageViewModel()
    @ObservedObject var photoPickerModel: PhotoPickerViewModel
    @EnvironmentObject var mapData : MapUIViewModel
        // @State var newAppInterest: [AppInterest]
    
    var body: some View {
                ScrollView {
                        ProtoMessage()
                        ForEach(viewModel.appInterest) { item in
                            BubblesComp(image: UIImage(data: item.photos!) ?? UIImage(systemName: "questionmark.square.fill")!, text: item.interest ?? "")
                        }
                        ForEach(viewModel.interestEntities) { item in
                            if let image = item.image {
                                BubblesComp(image: UIImage(data: image) ?? UIImage(systemName: "questionmark.square.fill")!, text: item.interest ?? "")
                            }
                        }
                }
                
                ButtonTurView(text: "GET EXPOSED")
                    .onTapGesture {
                        photoPickerModel.selectedPhotoToShow.removeAll()
                        viewModel.addInterest(interests: viewModel.appInterest)
                        onBoarding = 2
                        photoPickerModel.navAction.toggle()
                        mapData.showPhotoScreen = false
                    }
                    .onAppear {
                        viewModel.getInterest()
                        viewModel.getImageInterest(from: photoPickerModel.selectedPhotoToShow)
                    }
                    .navigationBarBackButtonHidden(true)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("\(Image(systemName: "chevron.backward"))")
                                    .foregroundColor(Color("Turquoise"))
                            }

                        }
                    })
    }
}

struct ProtoResultView_Previews: PreviewProvider {
    static var previews: some View {
        ProtoResultView(photoPickerModel: PhotoPickerViewModel())
            .environmentObject(PhotoPickerViewModel())
    }
}

struct ProtoMessage: View{
    var body: some View{
        HStack{
            Text("Your interest")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Spacer()
        }
        HStack{
            Text("Your result show that you are interested in a lot, Here are some of those things:")
                .foregroundColor(.gray)

        }
        
    }
}
