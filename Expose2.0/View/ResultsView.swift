//
//  ResultsView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/26/22.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var viewModel : MapUIViewModel
    
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    // For changing screen from the expose button
    @Binding var changeScreens: changeScreen
    var body: some View {
        ZStack {
            Image("MapBack")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                //.ignoresSafeArea()
                .blur(radius: 15)
            VStack {
                Message()
                Spacer()
                ScrollView(){
                    ForEach(viewModel.MLPhotoResults, id: \.self){ result in
                        Text(result)
                            .font(.title2)
                            .fontWeight(.black).textCase(.uppercase)
                            .padding()
                    }
                }
                GetExposed(changeScreens: $changeScreens)
                    .opacity(100)
                
                Spacer()
                    .frame( height: 50)
                
            }

            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Text("\(Image(systemName: "chevron.backward"))")
                    .font(.title2)
                    .foregroundColor(Color("Turquoise"))
                    .padding(6)
                    .padding(6.0)

            })
                    .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in

                        if(value.startLocation.x < 20 && value.translation.width > 100) {
                            self.mode.wrappedValue.dismiss()
                        }

                }))
            
        }.onAppear {
            print("PHOTOTOSCANCHECK: \(viewModel.photoToScanCheck)\n NEWPHOTOTOSCAN: \(viewModel.newPhotosToBeScanned)")
            if viewModel.photoToScanCheck != viewModel.newPhotosToBeScanned{
                viewModel.photoToScanCheck = viewModel.newPhotosToBeScanned
               
                print("BEFORE CONVERTING: \(viewModel.newPhotosToBeScanned.count)")
                
                // Classifies new photos to be scanned
                for photo in viewModel.newPhotosToBeScanned {
                    print("DID IT GET HERE")
                    viewModel.classifyImage(currentImageName: photo)
                }
                print("\n\nSAVING THIS AMOUNT OF PHOTOS \(viewModel.scannedPhotoToBeSaved.count)\n\n")
                print("\n\nSAVING THIS AMOUNT OF INTEREST \(viewModel.NewMLPhotoResults)\n\n")
                viewModel.create(interest: Interest(Interests: viewModel.NewMLPhotoResults, photos: viewModel.scannedPhotoToBeSaved))
                print("\n\n NEW PHOTO AMOUNT \(viewModel.newPhotosToBeScanned.count)\n\n")
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(changeScreens: .constant(changeScreen.contentView))
            .environmentObject(MapUIViewModel())
            .preferredColorScheme(.dark)
    }
}

struct Message: View{
    var body: some View{
        VStack(spacing: 78) {
            Text("YOUR RESULTS SHOW THAT YOU ARE INTERESTED IN ALOT")
                .font(.title2)
                .fontWeight(.black)

            Text("HERE ARE SOME OF THOSE THINGS:")
                .font(.title2)
                .fontWeight(.black)
        }
        .padding()
        .multilineTextAlignment(.center)
        
    }
}

struct GetExposed: View{
    @Binding var changeScreens: changeScreen
    @AppStorage("onBoarding") var onBoarding = 0
    var body: some View{
        VStack {
            Text("GET EXPOSED")
                .font(.title2)
                .fontWeight(.black)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color("Turquoise"))
                .cornerRadius(16)
                .padding(.horizontal, 16)
                
        }
        .onTapGesture {
            changeScreens = .homeView
            onBoarding = 2
            
        }
    }
}


