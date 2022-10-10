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
        Button(action: getExposedAction, label: {
            ButtonTurView(text: "GET EXPOSED")
        })
        .onAppear {
            onAppearAction()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                leadingButton
            }
        })
    } // MARK: VIEW
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


extension ProtoResultView{
    func getExposedAction(){
        photoPickerModel.selectedPhotoToShow.removeAll()
        viewModel.addInterest(interests: viewModel.appInterest)
        onBoarding = 2
        photoPickerModel.navActive.toggle()
        mapData.showPhotoScreen = false
    }
    
    func onAppearAction(){
        viewModel.getInterest()
        viewModel.getImageInterest(from: photoPickerModel.selectedPhotoToShow)
    }
    
    var leadingButton: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("\(Image(systemName: "chevron.backward"))")
                .foregroundColor(Color("Turquoise"))
        }
    }
}
